import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Librum.style


Item 
{
    id: root
    property string titleText: "Title"
    property string descriptionText: "Description"
    property double titleSize: 28
    property double descriptionSize: 14
    
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight
    
    
    ColumnLayout
    {
        id: layout
        spacing: 0
        
        Label
        {
            id: title
            text: root.titleText
            color: Style.colorTitle
            font.weight: Font.Bold
            font.pointSize: root.titleSize
        }
        
        Label
        {
            id: description
            text: root.descriptionText
            color: Style.colorPageSubtitle
            font.pointSize: root.descriptionSize
        }
    }
}
