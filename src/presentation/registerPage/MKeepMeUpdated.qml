import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Librum.style
import CustomComponents

Item {
    id: root
    property bool checked: false

    implicitWidth: 100
    implicitHeight: layout.height

    RowLayout {
        id: layout
        Layout.fillWidth: true
        spacing: 4

        MCheckBox {
            id: updatesCheckBox
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20

            onClicked: root.checked = !root.checked

            Keys.onReturnPressed: {
                this.toggle()
                root.checked = !root.checked
            }
        }

        Item {
            id: keepMeUpdatedText
            Layout.fillWidth: true
            Layout.preferredHeight: keepMeUpdatedTextFirst.implicitHeight
            Layout.leftMargin: 6

            Column {
                spacing: 2

                Label {
                    id: keepMeUpdatedTextFirst
                    text: "Keep me updated about new features and"
                    wrapMode: Text.WordWrap
                    font.pointSize: 11
                    color: Style.colorText
                }

                Label {
                    id: keepMeUpdatedTextSecond
                    text: "upcoming improvements."
                    wrapMode: Text.WordWrap
                    font.pointSize: 11
                    color: Style.colorText
                }
            }
        }
    }
}
