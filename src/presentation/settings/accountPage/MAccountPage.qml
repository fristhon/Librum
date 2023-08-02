import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import CustomComponents
import Librum.style
import Librum.icons
import Librum.globals
import Librum.controllers

MFlickWrapper {
    id: root
    property alias pageCleanup: pageCleanup

    contentHeight: page.implicitHeight

    Page {
        id: page
        anchors.fill: parent
        horizontalPadding: 48
        topPadding: 64
        bottomPadding: 22
        background: Rectangle {
            anchors.fill: parent
            color: Style.colorPageBackground
        }

        Component.onCompleted: {
            UserController.syncWithServer()
        }

        Shortcut {
            id: saveSettings
            sequence: StandardKey.Save
            onActivated: root.saveAccountSettings()
        }

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: 0

            RowLayout {
                id: titleRow
                Layout.fillWidth: true
                spacing: 0

                MTitle {
                    id: pageTitle
                    titleText: "Account"
                    descriptionText: UserController.firstName + " " + UserController.lastName
                    titleSize: 25
                    descriptionSize: 13.25
                }

                Item {
                    Layout.fillWidth: true
                }

                MButton {
                    id: saveButton
                    Layout.preferredWidth: 90
                    Layout.preferredHeight: 38
                    Layout.alignment: Qt.AlignBottom
                    borderWidth: 0
                    backgroundColor: Style.colorBasePurple
                    text: "Save"
                    fontSize: 12
                    fontWeight: Font.Bold
                    textColor: Style.colorFocusedButtonText
                    imagePath: Icons.checkWhite
                    imageSize: 14

                    onClicked: root.saveAccountSettings()
                }
            }

            Pane {
                id: profileBox
                Layout.fillWidth: true
                Layout.topMargin: 32
                topPadding: 25
                horizontalPadding: internal.boxPadding
                bottomPadding: 40
                background: Rectangle {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }

                RowLayout {
                    id: profileLayout
                    property int horizontalSpacing: 32

                    anchors.fill: parent
                    spacing: 0

                    ColumnLayout {
                        id: profileInputLayout
                        Layout.maximumWidth: Math.round(
                                                 profileLayout.width
                                                 - profileLayout.horizontalSpacing) / 2
                        Layout.fillWidth: true
                        spacing: 0

                        Label {
                            id: profileTitle
                            text: "Profile"
                            color: Style.colorText
                            font.pointSize: 16.5
                            font.weight: Font.DemiBold
                        }
                        component IMLabeledInputBox: MLabeledInputBox {

                            Layout.fillWidth: true
                            Layout.topMargin: 26
                            boxHeight: 40
                            headerText: "First name"
                            headerToBoxSpacing: 3
                            inputFontSize: 13
                            borderWidth: 1
                            borderRadius: 4

                            onEdited: internal.unsavedChanges = true
                        }

                        IMLabeledInputBox {
                            id: firstNameInput
                            text: internal.unsavedChanges ? text : UserController.firstName
                            headerText: "First name"
                        }

                        IMLabeledInputBox {
                            id: lastNameInput
                            text: internal.unsavedChanges ? text : UserController.lastName
                            headerText: "Last name"
                        }

                        IMLabeledInputBox {
                            id: emailInput
                            text: internal.unsavedChanges ? text : UserController.email
                            headerText: "Email"
                        }
                    }

                    MSelectProfilePictureArea {
                        id: profilePictureArea
                        Layout.fillWidth: true
                        Layout.maximumWidth: 312
                        Layout.preferredHeight: 190
                        Layout.topMargin: 76
                        Layout.rightMargin: 40
                        Layout.leftMargin: 32

                        onCurrentImageChanged: {
                            // Make sure that if we DELETE the picture, and no profile picture exists,
                            // we say that there are no unsaved changes. The only situation where this happens,
                            // is when there is no picture, we add a current picture WITHOUT saving and
                            // then delete it again. Since nothing changed, we don't want to set unsavedChanges.
                            if (currentImage == "!"
                                    && UserController.profilePicture.length === 0) {
                                internal.unsavedChanges = false
                                return
                            }

                            internal.unsavedChanges = true
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                }
            }

            Pane {
                id: changePasswordBox
                Layout.fillWidth: true
                Layout.topMargin: 26
                topPadding: 24
                horizontalPadding: internal.boxPadding
                bottomPadding: 50
                background: Rectangle {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }

                ColumnLayout {
                    id: passwordLayout
                    anchors.fill: parent
                    spacing: 0

                    Label {
                        id: passwordTitle
                        text: "Change password"
                        color: Style.colorText
                        font.pointSize: 16.5
                        font.weight: Font.DemiBold
                    }

                    RowLayout {
                        id: changePasswordInputLayout
                        Layout.fillWidth: true
                        spacing: profileLayout.horizontalSpacing
                        Layout.topMargin: 30

                        MLabeledInputBox {
                            id: passwordInput
                            Layout.fillWidth: true
                            boxHeight: 40
                            headerText: "Password"
                            headerToBoxSpacing: 3
                            inputFontSize: 13
                            borderWidth: 1
                            borderRadius: 4
                            image: Icons.eyeOn
                            toggledImage: Icons.eyeOff

                            onEdited: internal.unsavedChanges = true
                        }

                        MLabeledInputBox {
                            id: passwordConfirmationInput
                            Layout.fillWidth: true
                            boxHeight: 40
                            headerText: "Password confirmation"
                            headerToBoxSpacing: 3
                            inputFontSize: 13
                            borderWidth: 1
                            borderRadius: 4
                            image: Icons.eyeOn
                            toggledImage: Icons.eyeOff

                            onEdited: internal.unsavedChanges = true
                        }
                    }
                }
            }

            Pane {
                id: yourDataBox
                Layout.fillWidth: true
                Layout.topMargin: 26
                topPadding: 24
                horizontalPadding: internal.boxPadding
                bottomPadding: 38
                background: Rectangle {
                    color: Style.colorContainerBackground
                    border.color: Style.colorContainerBorder
                    radius: 4
                    antialiasing: true
                }

                ColumnLayout {
                    id: yourDataContentColumn
                    anchors.fill: parent
                    spacing: 0

                    Label {
                        id: yourDataTitle
                        text: "Your data"
                        color: Style.colorText
                        font.pointSize: 16.5
                        font.weight: Font.DemiBold
                    }

                    component IMLabeledCheckBox: MLabeledCheckBox {
                        Layout.fillWidth: true
                        Layout.topMargin: 30
                        boxWidth: 21
                        boxHeight: 21
                        fontSize: 13
                        fontColor: Style.colorText
                        spacing: 12
                        checked: true

                        onClicked: internal.unsavedChanges = true
                    }

                    Repeater {
                        model: ["Analyse your reading to make better recommendations", "Anonymously share the fromats of books you read (e.g. Pdf), to help us improve Librum", "Collect data on application crashes, so we can prevent it from happening again", "Collect data to display in your statistics"]
                        delegate: IMLabeledCheckBox {
                            text: modelData
                        }
                    }
                }
            }
        }
    }

    MWarningPopup {
        id: acceptDeletionPopup
        x: Math.round(
               root.width / 2 - implicitWidth / 2 - settingsSidebar.width / 2 - sidebar.width / 2)
        y: Math.round(
               root.height / 2 - implicitHeight / 2 - (root.height > implicitHeight + 80 ? 80 : 0))
        visible: false
        title: "Whoops"
        message: "It looks like you forgot to save your changes, are you sure that you dont want to save them?"
        leftButtonText: "Save"
        rightButtonText: "Don't save"
        buttonsWidth: 120

        onOpenedChanged: if (opened)
                             acceptDeletionPopup.giveFocus()
        onDecisionMade: close()
        onLeftButtonClicked: root.saveAccountSettings()
        onRightButtonClicked: internal.unsavedChanges = false
    }


    /*
      Since MAccountPage can have unsaved change, it needs MPageCleanup to
      ensure correct saving of data on page switching.
      */
    MPageCleanup {
        id: pageCleanup
        savePageAction: () => {
                            if (internal.unsavedChanges) {
                                acceptDeletionPopup.open()
                                return true
                            }
                            return false
                        }

        savingPageFinishedSignal: acceptDeletionPopup.decisionMade
    }

    QtObject {
        id: internal
        property bool unsavedChanges: false
        property int boxPadding: 40
    }

    function saveAccountSettings() {
        UserController.firstName = firstNameInput.text
        UserController.lastName = lastNameInput.text

        if (profilePictureArea.currentImage == "!")
            UserController.deleteProfilePicture()
        else
            UserController.profilePicture = profilePictureArea.currentImage

        profilePictureArea.currentImage = ""
        internal.unsavedChanges = false
    }
}
