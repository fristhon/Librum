import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import CustomComponents
import Librum.style
import Librum.icons
import Librum.controllers

MFlickWrapper {
    id: root
    contentHeight: Window.height < layout.implicitHeight ? layout.implicitHeight : Window.height

    Component.onCompleted: {
        // For some reason this prevents a SEGV. Directly calling the auto login
        // directly causes the application to crash on startup.
        autoLoginTimer.start()
    }
    Timer {
        id: autoLoginTimer
        interval: 0
        onTriggered: AuthController.tryAutomaticLogin()
    }

    Shortcut {
        sequence: "Ctrl+Return"
        onActivated: internal.login()
    }

    Connections {
        id: proccessLoginResult
        target: AuthController
        enabled: root.visible
        function onLoginFinished(errorCode, message) {
            internal.processLoginResult(errorCode, message)
        }
    }

    Connections {
        id: proccessLoadingUserResult
        target: UserController
        enabled: root.visible
        function onFinishedLoadingUser(success) {
            if (success)
                loadPage(homePage, sidebar.homeItem, false)
            else
                loginFailedPopup.open()
        }
    }

    Page {
        anchors.fill: parent
        bottomPadding: 22
        background: Rectangle {
            color: Style.colorAuthenticationPageBackground
        }

        ColumnLayout {
            id: layout
            anchors.centerIn: parent
            width: 544

            Pane {
                Layout.fillWidth: true
                topPadding: 48
                horizontalPadding: 71
                bottomPadding: 42
                background: Rectangle {
                    color: Style.colorContainerBackground
                    radius: 5
                }

                MColumnLayout {
                    width: parent.width
                    spacing: 0

                    MLogo {
                        id: logo
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 24
                        text: "Welcome back!"
                        color: Style.colorText
                        font.bold: true
                        font.pointSize: 26
                    }

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 4
                        text: "Log into your account"
                        color: Style.colorSubtitle
                        font.pointSize: 13
                    }

                    MLabeledInputBox {
                        id: emailInput
                        Layout.fillWidth: true
                        Layout.topMargin: 32
                        placeholderContent: "kaidoe@gmail.com"
                        placeholderColor: Style.colorPlaceholderText
                        headerText: "Email"

                        onEdited: internal.clearLoginError()
                    }

                    MLabeledInputBox {
                        id: passwordInput
                        Layout.fillWidth: true
                        Layout.topMargin: 22
                        headerText: "Password"
                        image: Icons.eyeOn
                        toggledImage: Icons.eyeOff

                        onEdited: internal.clearLoginError()
                    }

                    Label {
                        id: generalErrorText
                        Layout.topMargin: 8
                        visible: false
                        color: Style.colorErrorText
                    }

                    RowLayout {
                        Layout.preferredWidth: parent.width
                        Layout.fillWidth: true
                        Layout.topMargin: 24

                        MCheckBox {
                            id: rememberMeCheckBox
                            Layout.preferredWidth: 20
                            Layout.preferredHeight: 20

                            Keys.onReturnPressed: this.toggle()
                        }

                        Label {
                            text: "Remember me"
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 4
                            font.pointSize: 11
                            color: Style.colorText
                        }

                        Item {
                            id: widthFiller
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "Forgot password?"
                            Layout.alignment: Qt.AlignVCenter
                            Layout.leftMargin: 3
                            font.pointSize: 10.5
                            opacity: forgotPasswordPageRedirection.pressed ? 0.8 : 1
                            color: Style.colorBasePurple

                            MouseArea {
                                id: forgotPasswordPageRedirection
                                anchors.fill: parent

                                onClicked: loadPage(forgotPasswordPage)
                            }
                        }
                    }

                    MButton {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        Layout.topMargin: 42
                        borderWidth: 0
                        backgroundColor: Style.colorBasePurple
                        fontSize: 12
                        opacityOnPressed: 0.85
                        textColor: Style.colorFocusedButtonText
                        fontWeight: Font.Bold
                        text: "Login"

                        opacity: activeFocus ? opacityOnPressed : 1
                        onClicked: internal.login()
                        Keys.onReturnPressed: this.clicked()
                    }
                }
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 14
                text: "Don't have an account? Register"
                font.pointSize: 10.5
                opacity: registerLinkArea.pressed ? 0.8 : 1
                color: Style.colorBasePurple

                MouseArea {
                    id: registerLinkArea
                    anchors.fill: parent
                    onClicked: loadPage(registerPage)
                }
            }
        }
    }

    MWarningPopup {
        id: loginFailedPopup
        x: Math.round(root.width / 2 - implicitWidth / 2)
        y: Math.round(root.height / 2 - implicitHeight / 2) - 75
        visible: false
        title: "We're Sorry"
        message: "Logging you in failed, please try again later."
        leftButtonText: "Ok"
        rightButtonText: "Report"
        messageBottomSpacing: 8

        onDecisionMade: close()
        onOpenedChanged: if (opened)
                             loginFailedPopup.giveFocus()
    }

    QtObject {
        id: internal
        property color previousBorderColor: emailInput.borderColor

        function login() {
            AuthController.loginUser(emailInput.text, passwordInput.text,
                                     rememberMeCheckBox.checked)
        }

        function processLoginResult(errorCode, message) {
            if (errorCode === ErrorCode.NoError) {
                UserController.loadUser(rememberMeCheckBox.checked)
            } else {
                internal.setLoginError(errorCode, message)
            }
        }

        function setLoginError(errorCode, message) {
            switch (errorCode) {
            case ErrorCode.EmailOrPasswordIsWrong:
                emailInput.setError()
                passwordInput.errorText = message
                passwordInput.setError()
                break
            case ErrorCode.EmailAddressTooLong:
                // Fall through
            case ErrorCode.EmailAddressTooShort:
                // Fall through
            case ErrorCode.InvalidEmailAddressFormat:
                emailInput.errorText = message
                emailInput.setError()
                break
            case ErrorCode.PasswordTooLong:
                // Fall through
            case ErrorCode.PasswordTooShort:

                passwordInput.errorText = message
                passwordInput.setError()
                break
            default:
                generalErrorText.text = message
                generalErrorText.visible = true
            }
        }

        function clearLoginError() {
            emailInput.errorText = ""
            emailInput.clearError()
            passwordInput.errorText = ""
            passwordInput.clearError()

            generalErrorText.visible = false
            generalErrorText.text = ""
        }
    }
}
