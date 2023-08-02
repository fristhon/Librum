import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import CustomComponents
import Librum.style
import Librum.icons
import Librum.globals
import Librum.controllers

MFlickWrapper {
    id: root
    contentHeight: Window.height < layout.implicitHeight ? layout.implicitHeight : Window.height

    Page {
        id: page
        anchors.fill: parent
        bottomPadding: 16
        background: Rectangle {
            color: Style.colorAuthenticationPageBackground
        }

        Shortcut {
            sequence: "Ctrl+Return"
            onActivated: internal.registerUser()
        }

        Connections {
            target: AuthController

            function onRegistrationFinished(errorCode, message) {
                internal.proccessRegistrationResult(errorCode, message)
            }

            function onEmailConfirmationCheckFinished(confirmed) {
                internal.processEmailConfirmationResult(confirmed)
            }
        }

        ColumnLayout {
            id: layout
            width: 543
            anchors.centerIn: parent

            Pane {
                Layout.fillWidth: true
                topPadding: 48
                bottomPadding: 36
                horizontalPadding: 52
                background: Rectangle {
                    color: Style.colorContainerBackground
                    radius: 5
                }

                ColumnLayout {
                    id: contentLayout
                    width: parent.width
                    spacing: 0

                    MLogo {
                        id: logo
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Label {
                        Layout.topMargin: 24
                        Layout.alignment: Qt.AlignHCenter
                        color: Style.colorText
                        text: "Welcome!"
                        font.bold: true
                        font.pointSize: 26
                    }

                    Label {
                        Layout.fillWidth: true
                        Layout.topMargin: 8
                        Layout.alignment: Qt.AlignHCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "Your credentials are only used to authenticate yourself. "
                              + "Everything will be stored in a secure database."
                        font.pointSize: 13
                        color: Style.colorSubtitle
                        wrapMode: Text.WordWrap
                    }

                    Pane {
                        Layout.fillWidth: true
                        Layout.topMargin: 38
                        Layout.alignment: Qt.AlignHCenter
                        verticalPadding: 0
                        horizontalPadding: 20
                        background: Rectangle {
                            color: "transparent"
                        }

                        MColumnLayout {
                            id: inputLayout
                            width: parent.width
                            spacing: 0
                            rowNavigation: true

                            //I means Inline
                            component IMLabeledInputBox: MLabeledInputBox {
                                Layout.fillWidth: true
                                placeholderColor: Style.colorPlaceholderText
                                onEdited: internal.clearLoginError()
                            }

                            RowLayout {
                                id: nameInputLayout
                                Layout.preferredWidth: parent.width
                                spacing: 28

                                IMLabeledInputBox {
                                    id: firstNameInput
                                    headerText: 'First name'
                                    placeholderContent: "Kai"
                                }

                                IMLabeledInputBox {
                                    id: lastNameInput
                                    headerText: "Last name"
                                    placeholderContent: "Doe"
                                }
                            }

                            IMLabeledInputBox {
                                id: emailInput
                                Layout.topMargin: 19
                                headerText: 'Email'
                                placeholderContent: "kaidoe@gmail.com"
                            }

                            IMLabeledInputBox {
                                id: passwordInput
                                Layout.topMargin: 16
                                headerText: 'Password'
                                image: Icons.eyeOn
                                toggledImage: Icons.eyeOff
                            }

                            IMLabeledInputBox {
                                id: passwordConfirmationInput
                                Layout.topMargin: 16
                                headerText: 'Confirmation password'
                                image: Icons.eyeOn
                                toggledImage: Icons.eyeOff
                            }

                            Label {
                                id: generalErrorText
                                Layout.topMargin: 8
                                visible: false
                                color: Style.colorErrorText
                            }

                            MKeepMeUpdated {
                                id: keepMeUpdated
                                Layout.fillWidth: true
                                Layout.topMargin: 28
                            }

                            MAcceptPolicy {
                                id: acceptPolicy
                                Layout.fillWidth: true
                                Layout.topMargin: 32
                            }

                            MButton {
                                id: registerButton
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                Layout.topMargin: 44
                                borderWidth: 0
                                backgroundColor: Style.colorBasePurple
                                fontSize: 12
                                opacityOnPressed: 0.85
                                textColor: Style.colorFocusedButtonText
                                fontWeight: Font.Bold
                                text: "Let's start"
                                opacity: activeFocus ? opacityOnPressed : 1

                                onClicked: internal.registerUser()
                                Keys.onReturnPressed: this.clicked()
                            }
                        }
                    }
                }
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 14
                text: "Already have an account? Login"
                font.pointSize: 10.5
                opacity: loginRedirecitonLinkArea.pressed ? 0.8 : 1
                color: Style.colorBasePurple

                MouseArea {
                    id: loginRedirecitonLinkArea
                    anchors.fill: parent

                    onClicked: loadPage(loginPage)
                }
            }
        }
    }

    MWarningPopup {
        id: confirmEmailPopup
        x: Math.round(
               root.width / 2 - implicitWidth / 2 - page.horizontalPadding)
        y: Math.round(
               root.height / 2 - implicitHeight / 2 - page.topPadding - 65)
        visible: false
        singleButton: true
        messageBottomSpacing: 12
        title: "Confirm Your Email"
        message: "You're are almost ready to go!\nConfirm your email by clicking the link we sent you."
        leftButtonText: "Resend"

        onOpened: fetchEmailConfirmationTimer.start()
        onLeftButtonClicked: console.log("resend!")

        Timer {
            id: fetchEmailConfirmationTimer
            interval: 3000
            repeat: true

            onTriggered: AuthController.checkIfEmailConfirmed(emailInput.text)
        }
    }

    QtObject {
        id: internal

        function registerUser() {
            if (!passwordIsValid() || !policyIsAccepted())
                return

            AuthController.registerUser(firstNameInput.text,
                                        lastNameInput.text, emailInput.text,
                                        passwordInput.text,
                                        keepMeUpdated.checked)
        }

        function passwordIsValid() {
            if (passwordInput.text === passwordConfirmationInput.text)
                return true

            passwordConfirmationInput.errorText = "Passwords don't match"
            passwordConfirmationInput.setError()
            return false
        }

        function policyIsAccepted() {
            if (acceptPolicy.activated)
                return true

            acceptPolicy.setError()
            return false
        }

        function proccessRegistrationResult(errorCode, message) {
            if (errorCode === ErrorCode.NoError) {
                confirmEmailPopup.open()
                confirmEmailPopup.giveFocus()
            } else {
                internal.setRegistrationErrors(errorCode, message)
            }
        }

        function processEmailConfirmationResult(confirmed) {
            if (confirmed) {
                confirmEmailPopup.close()
                fetchEmailConfirmationTimer.stop()
                loadPage(loginPage)
            }
        }

        function setRegistrationErrors(errorCode, message) {
            switch (errorCode) {
            case ErrorCode.FirstNameTooLong:
                // Fall through
            case ErrorCode.FirstNameTooShort:
                firstNameInput.errorText = message
                firstNameInput.setError()
                break
            case ErrorCode.LastNameTooLong:
                // Fall through
            case ErrorCode.LastNameTooShort:
                lastNameInput.errorText = message
                lastNameInput.setError()
                break
            case ErrorCode.UserWithEmailAlreadyExists:
                // Fall through
            case ErrorCode.InvalidEmailAddressFormat:
                // Fall through
            case ErrorCode.EmailAddressTooShort:
                // Fall through
            case ErrorCode.EmailAddressTooLong:
                // Fall through
                emailInput.errorText = message
                emailInput.setError()
                break
            case ErrorCode.PasswordTooShort:
                // Fall through
            case ErrorCode.PasswordTooLong:
                passwordInput.errorText = message
                passwordInput.setError()
                break
            default:
                generalErrorText.text = message
                generalErrorText.visible = true
            }
        }

        function clearLoginError() {
            firstNameInput.clearError()
            lastNameInput.clearError()
            emailInput.clearError()
            passwordInput.clearError()
            passwordConfirmationInput.clearError()

            generalErrorText.visible = false
            generalErrorText.text = ""
        }
    }
}
