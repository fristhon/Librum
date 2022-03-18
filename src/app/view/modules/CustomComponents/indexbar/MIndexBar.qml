import QtQuick
import QtQuick.Layouts
import QtQuick.Controls


FocusScope
{
    id: root
    property int bookCount : 10
    
    implicitWidth: 1714
    implicitHeight: 32
    
    
    RowLayout
    {
        id: layout
        height: parent.height
        width: parent.width
        spacing: 0
        
        Rectangle
        {
            id: bookCountSelector
            Layout.preferredWidth: 58
            Layout.fillHeight: true
            color: properties.colorBackground
            border.color: properties.colorLightBorder
            radius: 4
            antialiasing: true
            
            RowLayout
            {
                id: inBookCountSelectorLayout
                anchors.centerIn: parent
                spacing: 5
                
                Label
                {
                    id: bookCountLabel
                    text: bookCount.toString()
                    color: properties.colorBaseText
                    font.family: properties.defaultFontFamily
                    font.pointSize: 11
                    font.bold: true
                }
                
                Image
                {
                    id: drowDownArrowImage
                    source: "/resources/images/arrow-filled-icon.svg"
                    sourceSize.width: 8
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
    
        Label
        {
            id: descriptionLabel
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 8
            text: "Entries per page"
            color: properties.colorLightText
            font.pointSize: 11
            font.family: properties.defaultFontFamily            
        }
        
        Item { Layout.fillWidth: true }
        
        Item
        {
            id: indexer
            Layout.preferredWidth: /*218*/ 230
            Layout.preferredHeight: 32
            
            RowLayout
            {
                id: indexerLayout
                height: parent.height
                spacing: 0
                
                Image
                {
                    id: leftArrow
                    rotation: 180
                    source: "/resources/images/black_right_icon.svg"
                    sourceSize.width: 30
                }
                
                Rectangle
                {
                    id: contentRect1
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    color: properties.colorBackground
                    border.color: properties.colorLightBorder                    
                    radius: 5
                    
                    Label
                    {
                        anchors.centerIn: parent
                        text: "1"
                        font.pointSize: 12
                        font.family: properties.defaultFontFamily
                        font.bold: true
                        color: properties.colorBasePurple
                    }
                }
                
                Rectangle
                {
                    id: contentRect2
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    color: "transparent"
                    border.color: "transparent"               
                    radius: 5
                    
                    Label
                    {
                        anchors.centerIn: parent
                        text: "2"
                        font.pointSize: 10.8
                        font.family: properties.defaultFontFamily
                        font.bold: false
                        color: properties.colorBaseText
                    }
                }
                
                Rectangle
                {
                    id: contentRect3
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    color: "transparent"
                    border.color: "transparent"               
                    radius: 5
                    
                    Label
                    {
                        anchors.centerIn: parent
                        text: "3"
                        font.pointSize: 10.5
                        font.family: properties.defaultFontFamily
                        font.bold: false
                        color: properties.colorBaseText
                    }
                }
                
                Rectangle
                {
                    id: contentRect4
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    color: "transparent"
                    border.color: "transparent"               
                    radius: 5
                    
                    Label
                    {
                        anchors.centerIn: parent
                        text: "..."
                        font.pointSize: 14
                        font.family: properties.defaultFontFamily
                        font.bold: false
                        color: properties.colorBaseText
                    }
                }
                
                Rectangle
                {
                    id: contentRect5
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    color: "transparent"
                    border.color: "transparent"               
                    radius: 5
                    
                    Label
                    {
                        anchors.centerIn: parent
                        text: "10"
                        font.pointSize: 10.5
                        font.family: properties.defaultFontFamily
                        font.bold: false
                        color: properties.colorBaseText
                    }
                }
                
                Image
                {
                    id: rightArrow
                    source: "/resources/images/black_right_icon.svg"
                    sourceSize.width: 30
                }
            }
        }
    }
}