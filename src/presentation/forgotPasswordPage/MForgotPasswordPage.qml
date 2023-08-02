import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import CustomComponents
import Librum.style
import Librum.icons

MFlickWrapper {
    id: root
    contentHeight: Window.height < layout.implicitHeight ? layout.implicitHeight
                                                           + page.bottomPadding : Window.height

    Page {
        id: page
        anchors.fill: parent
        bottomPadding: 50
        background: Rectangle {
            color: Style.colorAuthenticationPageBackground
        }

        Shortcut {
            sequence: "Ctrl+Return"
            onActivated: internal.sendPasswordResetEmail()
        }

        Shortcut {
            sequence: "Ctrl+Backspace"
            onActivated: internal.backToLoginPage()
        }

        ColumnLayout {
            id: layout
            anchors.centerIn: parent
            spacing: -92

            Image {
                z: 2
                Layout.alignment: Qt.AlignHCenter
                source: Icons.lockProtected
                sourceSize.width: 250
                fillMode: Image.PreserveAspectFit
            }

            Pane {
                Layout.preferredWidth: 542
                topPadding: 86
                bottomPadding: 28
                horizontalPadding: 0
                background: Rectangle {
                    color: Style.colorContainerBackground
                    radius: 6
                }

                ColumnLayout {
                    id: backgroundLayout
                    width: parent.width

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 32
                        text: "Forgot Password"
                        color: Style.colorText
                        font.bold: true
                        font.pointSize: 19
                    }

                    Label {
                        Layout.preferredWidth: 450
                        Layout.topMargin: 8
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Qt.AlignHCenter
                        text: "Enter your email and we'll send you a link to reset your password"
                        wrapMode: Text.WordWrap
                        color: Style.colorSubtitle
                        lineHeight: 1.1
                        font.weight: Font.Medium
                        font.pointSize: 12.5
                    }

                    MColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: internal.inWindowPadding
                        Layout.rightMargin: internal.inWindowPadding
                        Layout.topMargin: 12
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 0

                        MLabeledInputBox {
                            id: emailInput
                            Layout.fillWidth: true
                            placeholderContent: "kaidoe@gmail.com"
                            placeholderColor: Style.colorPlaceholderText
                            headerText: ""
                        }

                        Label {
                            id: errorText
                            Layout.topMargin: 10
                            visible: false
                            text: "We couldn't find your email"
                            color: Style.colorErrorText
                            font.pointSize: 11.75
                        }

                        Label {
                            id: successText
                            Layout.topMargin: 10
                            visible: false
                            text: "Email sent to: " + "placeholder@librum.com"
                            color: Style.colorGreenText
                            font.pointSize: 11.75
                        }

                        MButton {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            Layout.topMargin: (errorText.visible
                                               || successText.visible ? 32 : 56)
                            Layout.alignment: Qt.AlignHCenter
                            borderWidth: 0
                            backgroundColor: Style.colorBasePurple
                            text: "Send Email"
                            fontSize: 12.25
                            textColor: Style.colorFocusedButtonText
                            fontWeight: Font.Bold
                            opacityOnPressed: 0.85
                            opacity: activeFocus ? opacityOnPressed : 1

                            onClicked: internal.sendPasswordResetEmail()
                            Keys.onReturnPressed: this.clicked()
                        }

                        MButton {
                            Layout.preferredWidth: 145
                            Layout.preferredHeight: 42
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 18
                            centerContentHorizontally: false
                            borderWidth: 0
                            backgroundColor: "transparent"
                            opacityOnPressed: 0.7
                            text: "Back to Login"
                            fontSize: 12.20
                            fontWeight: Font.Medium
                            textColor: Style.colorUnfocusedButtonText
                            imagePath: Icons.arrowheadBackIcon
                            imageSize: 28
                            imageSpacing: 4
                            opacity: activeFocus ? opacityOnPressed : 1

                            onClicked: internal.backToLoginPage()
                            Keys.onReturnPressed: this.clicked()
                        }
                    }
                }
            }
        }
    }

    QtObject {
        id: internal
        property int inWindowPadding: 71

        function sendPasswordResetEmail() {
            successText.text = emailInput.text
            successText.visible = true
            emailInput.clearText()
        }

        function backToLoginPage() {
            loadPage(loginPage)
        }
    }
}
