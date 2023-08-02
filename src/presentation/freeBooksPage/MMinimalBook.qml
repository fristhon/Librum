import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.style
import Librum.icons

Item {
    id: root
    implicitWidth: 190
    implicitHeight: 304

    ColumnLayout {
        anchors.fill: parent
        spacing: 0


        /**
          A rectangle with rounded corners which is overlapping with the top half of
          the book to create a rounded top, while the rest of the book is rectangluar
          */
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 16
            radius: 4
            color: Style.colorBookImageBackground
        }


        /**
          The upper book half which contains the book cover
          */
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 230
            Layout.topMargin: -5
            color: Style.colorBookImageBackground

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                Image {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: -8
                    sourceSize.height: 241
                    source: Icons.bookCover
                    fillMode: Image.PreserveAspectFit
                }
            }
        }


        /**
          The lower book half which contains the book information
          */
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 65
            color: Style.colorBookBackground
            border.width: 1
            border.color: Style.colorBookBorder

            ColumnLayout {
                width: parent.width - internal.paddingInsideBook * 2
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: 4
                    text: "The books title which can be 2 lines long ..."
                    font.weight: Font.Medium
                    color: Style.colorTitle
                    font.pointSize: 11
                    lineHeight: 0.8
                    wrapMode: TextInput.WordWrap
                }

                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: 5
                    text: "Stephen R. Covey"
                    color: Style.colorLightText
                    font.pointSize: 10
                }
            }
        }
    }

    QtObject {
        id: internal
        property int paddingInsideBook: 14
    }
}
