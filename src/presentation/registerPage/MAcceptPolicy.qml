import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Librum.style
import CustomComponents

Item {
    id: root
    property bool activated: acceptCheckBox.checked
    property bool hasError: false

    implicitWidth: 200
    implicitHeight: layout.height

    onActivatedChanged: if (root.hasError)
                            root.clearError()

    RowLayout {
        id: layout
        width: parent.width
        spacing: 10

        MCheckBox {
            id: acceptCheckBox
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20

            Keys.onReturnPressed: {
                this.toggle()
            }
        }

        Label {
            id: text
            Layout.fillWidth: true
            text: 'I accept the <font color=' + Style.colorBasePurple + '>Terms of Service</font>
and the <font color=' + Style.colorBasePurple + '>privacy policy.</font>'
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
            font.pointSize: 11
            color: Style.colorText
        }
    }

    function setError() {
        root.hasError = true
        acceptCheckBox.borderWidth = 2
        acceptCheckBox.borderColor = Style.colorErrorBorder
        acceptCheckBox.uncheckedBackgroundColor = Style.colorErrorBackground
    }

    function clearError() {
        root.hasError = false
        acceptCheckBox.borderWidth = 1
        acceptCheckBox.borderColor = Style.colorCheckboxBorder
        acceptCheckBox.uncheckedBackgroundColor = "transparent"
    }
}
