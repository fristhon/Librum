#pragma once
#include <QObject>
#include "application_export.hpp"

// Each enum needs to be in a separate namespace due to a Qt bug reported at:
// https://bugreports.qt.io/browse/QTBUG-81792
//
// This causes not being able to register multiple enums to the Qt type system
// and to QML (Q_NAMESPACE and Q_ENUM_NS), if they are in the same namespace.
// The work around is to create a separate namespace for each enum.
namespace application::book_operation_status
{

Q_NAMESPACE_EXPORT(APPLICATION_LIBRARY)

enum class BookOperationStatus
{
    Success,
    OpeningBookFailed,
    BookDoesNotExist,
    PropertyDoesNotExist,
    TagDoesNotExist,
    TagAlreadyExists,
    OperationFailed
};

Q_ENUM_NS(BookOperationStatus)

}  // namespace application::book_operation_status

// Because the enum shouldn't be in a separate namespace in the first place,
// make the namespace available to all of its users to avoid syntactic clutter.
using namespace application::book_operation_status;
