import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import CustomComponents
import Librum.style
import Librum.icons

Popup {
    id: root
    implicitWidth: 751
    implicitHeight: layout.height
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

    onOpenedChanged: {
        //because this Popup exsits in a View
        //so must pass focuse manually
        if (root.opened) {
            layout.forceActiveFocus()
        }
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
                borderColor: "transparent"
                opacityOnPressed: 0.7
                radius: 6
                borderColorOnPressed: Style.colorButtonBorder
                imagePath: Icons.closePopup
                imageSize: 14

                interactiveFocus: false

                onClicked: root.close()
            }

            Pane {
                Layout.fillWidth: true
                horizontalPadding: 52
                bottomPadding: 42
                background: Rectangle {
                    color: "transparent"
                    radius: 6
                }

                ColumnLayout {
                    width: parent.width
                    spacing: 0

                    Label {
                        Layout.topMargin: 6
                        text: "Download book"
                        font.weight: Font.Bold
                        font.pointSize: 17
                        color: Style.colorTitle
                    }

                    RowLayout {
                        spacing: 28
                        Layout.fillWidth: true
                        Layout.topMargin: 32

                        Rectangle {
                            id: bookCoverArea
                            Layout.preferredWidth: 198
                            Layout.preferredHeight: 258
                            color: Style.colorBookImageBackground
                            radius: 4

                            Image {
                                anchors.centerIn: parent
                                Layout.alignment: Qt.AlignHCenter
                                sourceSize.height: bookCoverArea.height - 2
                                source: Icons.bookCover
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        ScrollView {
                            Layout.preferredHeight: 263
                            Layout.fillWidth: true
                            Layout.topMargin: -4
                            contentWidth: width
                            clip: true
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                            // contentItem is the underlying flickable of ScrollView
                            Component.onCompleted: contentItem.maximumFlickVelocity = 600

                            ColumnLayout {
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.rightMargin: 16
                                spacing: 16

                                component IMLabeledInputBox: MLabeledInputBox {
                                    Layout.fillWidth: true
                                    boxHeight: 34
                                    headerFontWeight: Font.Bold
                                    headerFontSize: 11.5
                                    headerToBoxSpacing: 3
                                    inputFontSize: 12
                                    inputFontColor: Style.colorReadOnlyInputText
                                    textPadding: 12
                                    borderWidth: 1
                                    borderRadius: 4
                                    readOnly: true
                                }

                                IMLabeledInputBox {
                                    headerText: "Title"
                                    text: "The 7 habits of highly effective people"
                                }
                                IMLabeledInputBox {
                                    headerText: "Authors"
                                    text: "Stephen R. Covey"
                                }
                                IMLabeledInputBox {
                                    headerText: "Publication"
                                    text: "United States: Dodd, Mead and Company,1922."
                                }
                                IMLabeledInputBox {
                                    headerText: "Language"
                                    text: "English"
                                }
                                IMLabeledInputBox {
                                    headerText: "Pages"
                                    text: "411"
                                }

                                IMLabeledInputBox {
                                    headerText: "Size"
                                    text: "2.3 MB"
                                }
                                IMLabeledInputBox {
                                    headerText: "Format"
                                    text: "PDF"
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        id: bookDescriptionLayout
                        Layout.fillWidth: true
                        Layout.topMargin: 28
                        spacing: 3

                        Label {
                            id: bookDescriptionHeader
                            Layout.fillWidth: true
                            text: "Content"
                            font.pointSize: 11.5
                            font.weight: Font.Bold
                            color: Style.colorTitle
                        }

                        Rectangle {
                            id: bookDescriptionField
                            Layout.fillWidth: true
                            Layout.preferredHeight: 78
                            color: "transparent"
                            radius: 5
                            border.width: 1
                            border.color: Style.colorContainerBorder

                            TextArea {
                                id: bookDescriptionTextArea
                                anchors.fill: parent
                                leftPadding: 12
                                rightPadding: 12
                                topPadding: 8
                                bottomPadding: 8
                                selectByMouse: true
                                text: "Your habits determine your character and later define"
                                      + " your life. Don’t blame outside factors when you fail in life." + " Also, don’t think that succeeding in one area of your life will"
                                      + " mean that you’re destined for triumph."
                                wrapMode: Text.WordWrap
                                color: Style.colorReadOnlyInputText
                                font.pointSize: 12
                                readOnly: true

                                background: Rectangle {
                                    anchors.fill: parent
                                    radius: bookDescriptionField.radius
                                    color: "transparent"
                                }
                            }
                        }
                    }

                    RowLayout {
                        id: buttonsLayout
                        Layout.topMargin: 42
                        spacing: 16

                        component IMButton: MButton {

                            Layout.preferredWidth: 140
                            Layout.preferredHeight: 38
                            active: true
                            text: "Download"
                            textColor: activeFocus ? Style.colorFocusedButtonText : Style.colorUnfocusedButtonText
                            fontWeight: Font.Bold
                            fontSize: 12
                            borderWidth: activeFocus ? 0 : 1
                            backgroundColor: activeFocus ? Style.colorBasePurple : "transparent"

                            Keys.onReturnPressed: this.clicked()
                        }

                        IMButton {
                            text: "Download"
                            imageSize: 18
                            imagePath: activeFocus ? Icons.downloadSelected : ""

                            onClicked: internal.downloadBook()
                        }

                        IMButton {
                            text: "Cancel"
                            opacityOnPressed: 0.7

                            onClicked: root.close()
                        }
                    }
                }
            }
        }
    }

    QtObject {
        id: internal

        function downloadBook() {// TODO: Implement
        }
    }
}
