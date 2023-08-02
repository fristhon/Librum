import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.platform
import CustomComponents
import Librum.style
import Librum.icons
import Librum.controllers
import Librum.globals

Popup {
    id: root
    implicitWidth: 751
    implicitHeight: layout.implicitHeight
    focus: true
    padding: 0
    background: Rectangle {
        radius: 6
        color: Style.colorPopupBackground
    }
    modal: true
    Overlay.modal: Rectangle {
        color: Style.colorPopupDim
        opacity: 1
    }

    onAboutToHide: internal.unloadData()
    onAboutToShow: {
        internal.loadData()
    }

    MFlickWrapper {
        anchors.fill: parent
        contentHeight: layout.height

        MColumnLayout {
            id: layout
            width: parent.width
            spacing: 0
            rowNavigation: true

            MButton {
                Layout.preferredHeight: 32
                Layout.preferredWidth: 32
                Layout.topMargin: 12
                Layout.rightMargin: 14
                Layout.alignment: Qt.AlignRight
                backgroundColor: "transparent"
                opacityOnPressed: 0.7
                borderColor: "transparent"
                radius: 6
                borderColorOnPressed: Style.colorButtonBorder
                imagePath: Icons.closePopup
                imageSize: 14
                onClicked: root.close()

                interactiveFocus: false
            }

            Label {
                Layout.topMargin: 20
                Layout.leftMargin: 52
                text: "Book details"
                font.weight: Font.Bold
                font.pointSize: 17
                color: Style.colorTitle
            }


            /*
              The SplitView contains all the book information, it holds the book cover
              on the left side, and the book data on the right.
              */
            SplitView {
                Layout.fillWidth: true
                Layout.preferredHeight: 320
                Layout.topMargin: 36
                Layout.leftMargin: 52
                Layout.rightMargin: 52
                orientation: Qt.Horizontal
                spacing: 10
                smooth: true
                // Create explicit handle to make the grabbable area bigger
                handle: RowLayout {
                    width: 9
                    spacing: 0

                    Rectangle {
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        color: "transparent"
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.fillHeight: true
                        color: Style.colorDarkSeparator
                    }

                    Rectangle {
                        Layout.preferredWidth: 4
                        Layout.fillHeight: true
                        color: "transparent"
                    }
                }


                /*
                  The book cover side of the SplitView
                  */
                Item {
                    SplitView.preferredWidth: 218
                    SplitView.minimumWidth: 80
                    SplitView.maximumWidth: 246

                    ColumnLayout {
                        width: parent.width - 20
                        anchors.verticalCenter: parent.verticalCenter
                        clip: true
                        spacing: 0

                        Rectangle {
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 240
                            Layout.topMargin: 4
                            color: Style.colorBookImageBackground
                            radius: 4

                            Image {
                                id: bookCover
                                visible: Globals.selectedBook !== null ? source != "" : false
                                anchors.centerIn: parent
                                sourceSize.width: 188
                                sourceSize.height: 238
                            }

                            Label {
                                anchors.centerIn: parent
                                visible: !bookCover.visible
                                color: Style.colorNoImageLabel
                                text: Globals.selectedBook
                                      !== null ? "." + Globals.selectedBook.format : ""
                                font.pointSize: 20
                                font.bold: true
                            }
                        }

                        RowLayout {
                            Layout.topMargin: 22
                            spacing: 14

                            component ICoverMButton: MButton {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 34
                                borderWidth: 1
                                opacityOnPressed: 0.8
                                textColor: Style.colorText
                                fontWeight: Font.DemiBold
                                fontSize: 11.5
                                Keys.onReturnPressed: {
                                    this.clicked()
                                }
                            }

                            ICoverMButton {
                                text: "Change"
                                backgroundColor: activeFocus ? Style.colorBasePurple : "transparent"
                                onClicked: chooseImageDialog.open()
                            }

                            ICoverMButton {
                                text: "Delete"
                                backgroundColor: activeFocus ? Style.colorRed : "transparent"
                                onClicked: bookCover.source = ""
                            }
                        }
                    }
                }


                /*
                  The book data side of the SplitView
                  */
                Item {
                    SplitView.minimumWidth: 100
                    SplitView.fillWidth: true

                    ScrollView {
                        id: dataSideScrollView
                        anchors.fill: parent
                        anchors.topMargin: 0
                        anchors.rightMargin: -10
                        anchors.leftMargin: 26
                        contentWidth: width
                        clip: true
                        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                        Component.onCompleted: {
                            contentItem.maximumFlickVelocity = 600
                            contentItem.contentY = 0
                        }

                        ColumnLayout {
                            id: dataSideLayout
                            width: parent.width - 18
                            height: parent.height
                            anchors.rightMargin: 8
                            spacing: 13

                            component IMLabeledInputBox: MLabeledInputBox {
                                Layout.fillWidth: true
                                boxHeight: 34
                                headerFontWeight: Font.Bold
                                headerFontSize: 11.5
                                placeholderContent: "Unknown"
                                placeholderColor: Style.colorPlaceholderText
                                headerToBoxSpacing: 3
                                inputFontSize: 12
                                inputFontColor: Style.colorLightInputText
                                textPadding: 12
                                borderWidth: 1
                                borderRadius: 4
                            }

                            IMLabeledInputBox {
                                id: titleField
                                headerText: "Title"
                                text: Globals.selectedBook
                                      !== null ? Globals.selectedBook.title : ""
                            }

                            IMLabeledInputBox {
                                id: authorsField
                                headerText: "Authors"
                                text: Globals.selectedBook
                                      !== null ? Globals.selectedBook.authors : ""
                            }

                            IMLabeledInputBox {
                                headerText: "Pages"
                                text: Globals.selectedBook !== null ? Globals.selectedBook.pageCount : internal.placeholderText
                                readOnly: true
                            }

                            MComboBox {
                                id: languageComboBox
                                Layout.fillWidth: true
                                Layout.preferredHeight: 53
                                multiSelect: false
                                headerText: "Language"
                                headerFontSize: 11.5
                                headerFontColor: Style.colorTitle
                                dropdownIconSize: 9
                                maxHeight: 200
                                model: ListModel {
                                    ListElement {
                                        text: "English"
                                    }
                                    ListElement {
                                        text: "German"
                                    }
                                    ListElement {
                                        text: "Italian"
                                    }
                                    ListElement {
                                        text: "French"
                                    }
                                    ListElement {
                                        text: "Romanian"
                                    }
                                    ListElement {
                                        text: "Spanish"
                                    }
                                    ListElement {
                                        text: "Mandarin"
                                    }
                                    ListElement {
                                        text: "Portugese"
                                    }
                                    ListElement {
                                        text: "Hindi"
                                    }
                                    ListElement {
                                        text: "Bengali"
                                    }
                                    ListElement {
                                        text: "Russian"
                                    }
                                    ListElement {
                                        text: "Arabic"
                                    }
                                    ListElement {
                                        text: "Japanese"
                                    }
                                    ListElement {
                                        text: "Indonesian"
                                    }
                                    ListElement {
                                        text: "Turkish"
                                    }
                                    ListElement {
                                        text: "Korean"
                                    }
                                    ListElement {
                                        text: "Hungarian"
                                    }
                                    ListElement {
                                        text: "Thai"
                                    }
                                    ListElement {
                                        text: "Swahli"
                                    }
                                    ListElement {
                                        text: "Dutch"
                                    }
                                }
                            }

                            IMLabeledInputBox {
                                id: documentCreatorField
                                Layout.fillWidth: true
                                headerText: "Document creator"
                                text: Globals.selectedBook
                                      !== null ? Globals.selectedBook.creator : ""
                            }

                            IMLabeledInputBox {
                                id: creationDateField
                                headerText: "Creation date"
                                text: Globals.selectedBook
                                      !== null ? Globals.selectedBook.creationDate : ""
                            }

                            IMLabeledInputBox {
                                id: formatField
                                headerText: "Format"
                                text: Globals.selectedBook !== null
                                      && Globals.selectedBook.format !== "" ? Globals.selectedBook.format : internal.placeholderText
                                readOnly: true
                            }

                            IMLabeledInputBox {
                                headerText: "Document size"
                                text: Globals.selectedBook !== null
                                      && Globals.selectedBook.documentSize
                                      !== "" ? Globals.selectedBook.documentSize : internal.placeholderText
                                readOnly: true
                            }

                            IMLabeledInputBox {
                                headerText: "Added"
                                text: Globals.selectedBook !== null ? Globals.selectedBook.addedToLibrary : internal.placeholderText
                                readOnly: true
                            }

                            IMLabeledInputBox {
                                headerText: "Last opened"
                                text: Globals.selectedBook !== null ? Globals.selectedBook.lastOpened : internal.placeholderText
                                readOnly: true
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.preferredWidth: parent.width
                Layout.topMargin: 65
                Layout.bottomMargin: 42
                Layout.leftMargin: 52
                Layout.rightMargin: 52
                spacing: 16

                component IMButton: MButton {
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 38
                    Layout.alignment: Qt.AlignLeft
                    borderWidth: activeFocus ? 0 : 1
                    backgroundColor: activeFocus ? Style.colorBasePurple : "transparent"
                    textColor: activeFocus ? Style.colorFocusedButtonText : Style.colorUnfocusedButtonText
                    fontWeight: Font.Bold
                    fontSize: 12
                    Keys.onReturnPressed: this.clicked()
                }

                IMButton {
                    text: "Apply"
                    onClicked: {
                        internal.saveData()
                        root.close()
                    }
                }

                IMButton {
                    text: "Cancel"
                    textColor: activeFocus ? Style.colorFocusedButtonText : Style.colorUnfocusedButtonText
                    opacityOnPressed: 0.7
                    onClicked: {
                        root.close()
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                IMButton {
                    Layout.alignment: Qt.AlignRight
                    backgroundColor: activeFocus ? Style.colorRed : "transparent"
                    opacityOnPressed: 0.7
                    text: "Delete"
                    imagePath: activeFocus ? Icons.trashHighlighted : Icons.trash
                    imageSize: 17
                    imageSpacing: 10
                    onClicked: acceptDeletionPopup.open()
                }
            }
        }
    }

    MWarningPopup {
        id: acceptDeletionPopup
        x: root.width / 2 - implicitWidth / 2
        y: root.height / 2 - implicitHeight / 2 - 30
        visible: false
        title: "Delete Book?"
        message: "Deleting a book is a permanent action, no one will be\n able to restore it afterwards!"
        leftButtonText: "No, Keep Book"
        rightButtonText: "Yes, Delete Book"
        buttonsWidth: 180
        messageBottomSpacing: 10

        onOpenedChanged: if (opened)
                             acceptDeletionPopup.giveFocus()
        onDecisionMade: close()
        onRightButtonClicked: {
            BookController.deleteBook(Globals.selectedBook.uuid)
            root.close()
        }
    }

    FileDialog {
        id: chooseImageDialog
        acceptLabel: "Select"
        fileMode: FileDialog.OpenFile
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: ["All files (*.png *.jpg *.jpg *.jpeg)", "png files (*.png)", "jpg files (*.jpg)", "jpeg files (*.jpeg)"]

        onAccepted: bookCover.source = file
    }

    QtObject {
        id: internal
        property string placeholderText: "Unknown"

        function saveData() {
            var operationsMap = {}

            if (titleField.text !== Globals.selectedBook.title)
                operationsMap[BookController.MetaProperty.Title] = titleField.text

            if (authorsField.text !== Globals.selectedBook.authors)
                operationsMap[BookController.MetaProperty.Authors] = authorsField.text

            if (languageComboBox.text !== Globals.selectedBook.language
                    && languageComboBox.text != "")
                operationsMap[BookController.MetaProperty.Language] = languageComboBox.text

            if (documentCreatorField.text !== Globals.selectedBook.creator
                    && documentCreatorField.text != "")
                operationsMap[BookController.MetaProperty.Creator] = documentCreatorField.text

            if (creationDateField.text !== Globals.selectedBook.creationDate
                    && creationDateField.text != internal.placeholderText)
                operationsMap[BookController.MetaProperty.CreationDate] = creationDateField.text

            if (formatField.text !== Globals.selectedBook.format
                    && formatField.text != internal.placeholderText)
                operationsMap[BookController.MetaProperty.Format] = formatField.text

            BookController.updateBook(Globals.selectedBook.uuid, operationsMap)

            // Handle book cover specially
            if (bookCover.source != Globals.selectedBook.coverPath)
                // Needs to be !=, the types are different (QUrl and QString)
                BookController.changeBookCover(Globals.selectedBook.uuid,
                                               bookCover.source)
        }

        function loadData() {
            if (Globals.selectedBook.coverPath !== "")
                bookCover.source = Qt.binding(function () {
                    return Globals.selectedBook.coverPath
                })

            if (Globals.selectedBook.language !== "")
                languageComboBox.setDefaultItem(Globals.selectedBook.language)
        }

        function unloadData() {
            languageComboBox.deselectCurrenItem()
        }
    }
}
