#include "book_controller.hpp"
#include <QBuffer>
#include <QVariant>
#include "book_dto.hpp"
#include "book_operation_status.hpp"
#include "tag.hpp"
#include "tag_dto.hpp"


namespace adapters::controllers
{

using namespace domain::models;
using application::BookOperationStatus;

BookController::BookController(application::IBookService* bookService)
    : m_bookChacheChanged(true), m_bookService(bookService),
      m_libraryModel(m_bookService->getBooks())
{
    // book insertion
    QObject::connect(m_bookService, &application::IBookService::bookInsertionStarted,
                     &m_libraryModel, &data_models::LibraryModel::startInsertingRow);
    QObject::connect(m_bookService, &application::IBookService::bookInsertionEnded,
                     &m_libraryModel, &data_models::LibraryModel::endInsertingRow);
    
    // book deletion
    QObject::connect(m_bookService, &application::IBookService::bookDeletionStarted,
                     &m_libraryModel, &data_models::LibraryModel::startDeletingBook);
    QObject::connect(m_bookService, &application::IBookService::bookDeletionEnded,
                     &m_libraryModel, &data_models::LibraryModel::endDeletingBook);
    
    // tags changed
    QObject::connect(m_bookService, &application::IBookService::tagsChanged,
                     &m_libraryModel, &data_models::LibraryModel::refreshTags);
    
    // book cover processing
    QObject::connect(m_bookService, &application::IBookService::bookCoverGenerated,
                     &m_libraryModel, &data_models::LibraryModel::processBookCover);
}


int BookController::addBook(const QString& path)
{
    auto result = m_bookService->addBook(path);
    if(result == BookOperationStatus::Success)
    {
        m_bookChacheChanged = true;
        return static_cast<int>(BookOperationStatus::Success);
    }
    
    return static_cast<int>(BookOperationStatus::BookAlreadyExists);
}

int BookController::deleteBook(const QString& title)
{
    auto result = m_bookService->deleteBook(title);
    if(result == BookOperationStatus::Success)
    {
        m_bookChacheChanged = true;
        return static_cast<int>(BookOperationStatus::Success);
    }
    
    return static_cast<int>(BookOperationStatus::BookDoesNotExist);
}

int BookController::updateBook(const QString& title, const QVariantMap& operations)
{
    auto bookToUpdate = m_bookService->getBook(title);
    if(!bookToUpdate)
        return static_cast<int>(BookOperationStatus::BookDoesNotExist);
    
    auto updatedBook = *bookToUpdate;
    for(const auto& key : operations.keys())
    {
        if(key == "Title")
        {
            auto title = operations.value("Title");
            updatedBook.setTitle(qvariant_cast<QString>(title));
        }
        else if(key == "Cover")
        {
            auto cover = operations.value("Cover");
            updatedBook.setTitle(qvariant_cast<QByteArray>(cover));
        }
        else
        {
            return static_cast<int>(BookOperationStatus::PropertyDoesNotExist);
        }
    }
    
    m_bookChacheChanged = true;
    
    m_bookService->updateBook(title, updatedBook);
    return static_cast<int>(BookOperationStatus::Success);
}

int BookController::addTag(const QString& title, const QString& tagName)
{
    Tag tagToAdd(tagName);
    if(m_bookService->addTag(title, tagToAdd) == BookOperationStatus::Success)
    {
        m_bookChacheChanged = true;
        return static_cast<int>(BookOperationStatus::Success);
    }
    
    return static_cast<int>(BookOperationStatus::TagAlreadyExists);
}

int BookController::removeTag(const QString& title, const QString& tagName)
{
    Tag tagToRemove(tagName);
    if(m_bookService->removeTag(title, tagToRemove) == BookOperationStatus::Success)
    {
        m_bookChacheChanged = true;
        return static_cast<int>(BookOperationStatus::Success);
    }
    
    return static_cast<int>(BookOperationStatus::TagDoesNotExist);
}

dtos::BookDto BookController::getBook(const QString& title)
{
    if(m_bookChacheChanged)
        refreshBookChache();
    
    return *getBookFromChache(title);
}

int BookController::getBookCount() const
{
    return m_bookService->getBookCount();
}

data_models::LibraryModel* BookController::getLibraryModel()
{
    return &m_libraryModel;
}

void BookController::refreshBookChache()
{
    const auto& books = m_bookService->getBooks();
    
    m_bookCache.clear();
    for(const auto& book : books)
    {
        dtos::BookDto bookDto;
        bookDto.title = book.getTitle();
        bookDto.author = book.getAuthor();
        bookDto.filePath = book.getFilePath();
        bookDto.creator = book.getCreator();
        bookDto.creationDate = book.getCreationDate();
        bookDto.format = book.getFormat();
        bookDto.documentSize = book.getDocumentSize();
        bookDto.pagesSize = book.getPagesSize();
        bookDto.pageCount = book.getPageCount();
        bookDto.addedToLibrary = book.getAddedToLibrary();
        bookDto.lastModified = book.getLastModified();
        bookDto.cover = book.getCover();
        
        for(std::size_t i = 0; i < book.getTags().size(); ++i)
        {
            dtos::TagDto tagDto;
            tagDto.name = book.getTags()[i].getName();
            
            bookDto.tags.push_back(tagDto);
        }
        
        m_bookCache.emplace_back(std::move(bookDto));
    }
    
    m_bookChacheChanged = false;
}

dtos::BookDto* BookController::getBookFromChache(const QString& title)
{
    for(std::size_t i = 0; i < m_bookCache.size(); ++i)
    {
        if(m_bookCache[i].title == title)
            return &m_bookCache[i];
    }
    
    return nullptr;
}

} // namespace adapters::controllers