import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import librum.extensions.sidebar
import "../"

FocusScope
{
    id: root
    implicitWidth: closedWidth
    implicitHeight: Window.height
    
    property int  closedWidth : 72
    property int  openedWidth : 232
    property bool sidebarOpened : false
    property int  selectedTab : SidebarState.Home
    property MSidebarItem selectedTabRef : null
    
    Rectangle
    {
        id: container
        color: properties.colorBackground
        height: parent.height
        width: parent.width
        
        MSidebarAnimations
        {
            id: animations
        }
        
        ColumnLayout
        {
            id: mainLayout
            width: parent.width
            height: parent.height
            spacing: 0
            
            RowLayout
            {
                id: logo
                Layout.topMargin: 14
                Layout.leftMargin: 14
                spacing: 0
                
                MLogo
                {
                    id: logoIcon
                    Layout.preferredWidth: 44
                    Layout.preferredHeight: 44
                }
                
                Label
                {
                    id: logoLabel
                    visible: false
                    Layout.leftMargin: 20
                    text: "Librum"
                    font.bold: true
                    font.family: properties.defaultFontFamily
                    font.pointSize: 16
                    color: properties.colorBaseTitle
                }
            }
            
            Rectangle
            {
                id: topSeparator
                Layout.preferredWidth: root.width
                Layout.preferredHeight: 2
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 15
                color: properties.colorSidebarSeparator
            }
            
            MSidebarItem
            {
                id: freeBooksButton
                Layout.topMargin: 16
                Layout.leftMargin: 10
                imageWidth: 45
                imageHeight: 45
                imageSource: "/resources/images/download-icon.svg"
                labelContent: "Free books"
                
                onClicked: {
                    if(true)
                        loadPage("FreeBooksPage");
                }
            }            
            
            Rectangle
            {
                id: smallSeperator1
                Layout.preferredWidth: parent.width * 0.61
                Layout.preferredHeight: 2
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 16
                color: properties.colorSidebarSeparator
            }
            
            MSidebarItem
            {
                id: homeButton
                Layout.topMargin: 15
                Layout.leftMargin: 10
                imageWidth: 30
                imageHeight: 28
                imageSource: "/resources/images/home-icon.svg"
                labelContent: "Home"
                
                onClicked: {
                    if(true)
                        loadPage("HomePage");
                }
            }
            
            MSidebarItem
            {
                id: statisticsButton
                Layout.topMargin: 13
                Layout.leftMargin: 10
                imageWidth: 28
                imageHeight: 28
                imageSource: "/resources/images/pieChart-icon.svg"
                labelContent: "Statistics"
                
                onClicked: {
                    if(true)
                        loadPage("StatisticsPage");
                }
            }
            
            Rectangle
            {
                id: smallSeperator2
                Layout.preferredWidth: parent.width * 0.61
                Layout.preferredHeight: 2
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 15
                color: properties.colorSidebarSeparator
            }
            
            MSidebarItem
            {
                id: toolsButton
                Layout.topMargin: 15
                Layout.leftMargin: 10
                imageWidth: 30
                imageHeight: 30
                imageSource: "/resources/images/wrench-icon.svg"
                labelContent: "Tools"
                
                onClicked: {
                    if(true)
                        loadPage("ToolsPage");
                }
            }
            
            MSidebarItem
            {
                id: addOnButton
                Layout.topMargin: 13
                Layout.leftMargin: 10
                imageWidth: 31
                imageHeight: 31
                imageSource: "/resources/images/puzzle-icon.svg"
                labelContent: "Add-ons"
                
                onClicked: {
                    if(true)
                        loadPage("AddOnsPage");
                }
            }
            
            MSidebarItem
            {
                id: settingsButton
                Layout.topMargin: 13
                Layout.leftMargin: 10
                imageWidth: 36
                imageHeight: 36
                imageSource: "/resources/images/settings-icon.svg"
                labelContent: "Settings"
                
                onClicked: {
                    if(true)
                        loadPage("SettingsPage");
                }
            }
            
            Item
            {
                id: emptySpace
                Layout.preferredWidth: parent.width
                Layout.fillHeight: true
                Layout.minimumHeight: 30
                Layout.alignment: Qt.AlignTop
            }
            
            Rectangle
            {
                id: bottomSeparator
                Layout.preferredWidth: root.width
                Layout.preferredHeight: 2
                Layout.alignment: Qt.AlignBottom
                color: properties.colorSidebarSeparator
            }
            
            
            
            Rectangle
            {
                id: profileBox
                Layout.preferredWidth: root.width
                Layout.preferredHeight: 70
                Layout.alignment: Qt.AlignBottom
                color: "transparent"
                
                RowLayout
                {
                    width: root.width + expandButton.width / 2.2  // So the button goes over the border
                    height: parent.height
                    spacing: 0
                    
                    Rectangle
                    {
                        id: profilePicture
                        Layout.preferredWidth: 36
                        Layout.preferredHeight: 36
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                        Layout.leftMargin: 18
                        radius: width
                        antialiasing: true
                        color: "#DBCE5F"
                        
                        Label
                        {
                            id: initials
                            anchors.centerIn: parent
                            text: "DL"
                            font.pointSize: 12
                            font.bold: true
                            font.family: properties.defaultFontFamily
                            color: properties.colorBrightText
                        }
                    }
                    
                    Rectangle
                    {
                        id: expandButton
                        Layout.preferredWidth: 23
                        Layout.preferredHeight: 24
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                        radius: 2
                        border.width: 1
                        border.color: properties.colorLightBorder
                        
                        Image
                        {
                            id: rightArrowImage
                            sourceSize.width: 20
                            sourceSize.height: 20
                            anchors.centerIn: parent
                            source: "/resources/images/right_icon.svg"
                        }
                        
                        MouseArea
                        {
                            id: expandMouseArea
                            anchors.fill: parent
                            onClicked:
                            {
                                if(root.sidebarOpened)
                                {
                                    animations.closeAnimation.start();
                                    root.selectedTabRef.closeAnimation.start();
                                    root.sidebarOpened = false;
                                }
                                else
                                {
                                    animations.openAnimation.start();
                                    root.selectedTabRef.openAnimation.start();
                                    root.sidebarOpened = true;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        Component.onCompleted: {
            switch(root.selectedTab)
            {
            case SidebarState.FreeBooks:
                freeBooksButton.selected = true;
                root.selectedTabRef = freeBooksButton;
                break;
            case SidebarState.Home:
                homeButton.selected = true;
                root.selectedTabRef = homeButton;
                break;
            case SidebarState.Statistics:
                statisticsButton.selected = true;
                root.selectedTabRef = statisticsButton;
                break;
            case SidebarState.Tools:
                toolsButton.selected = true;
                root.selectedTabRef = toolsButton;
                break;
            case SidebarState.AddOns:
                addOnButton.selected = true;
                root.selectedTabRef = addOnButton;
                break;
            case SidebarState.Settings:
                settingsButton.selected = true;
                root.selectedTabRef = settingsButton;
                break;
            }
        }
    }
}