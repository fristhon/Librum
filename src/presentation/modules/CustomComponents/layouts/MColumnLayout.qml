import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import ".."

//this layout can automate arrow keys navigation
//between those componets that are interactable
ColumnLayout {
    id: root

    property var interactiveChilds: []
    property int interactiveChildIndex: 0
    //this is a property for improving UX
    //when there is a Row\RowLayout in a ColumnLayout
    //a separated navigationable RowLayout can be created
    //with same logic as this component if needed
    property bool rowNavigation: false

    Connections {
        target: baseRoot
        enabled: root.visible
        function onActiveFocusItemChanged() {
            //focus is on another application or App is minimized
            if (!baseRoot.activeFocusItem) {
                return
            }

            //`focusReason` is not always reliable
            if (baseRoot.activeFocusItem.focusReason === undefined) {
                if (interactiveChilds.length > 0) {
                    updateFocusByIndex()
                }
                return
            }

            //user can break focus order by a click
            //so index must be updated manually
            if (baseRoot.activeFocusItem.focusReason === Qt.MouseFocusReason) {
                for (var index in interactiveChilds) {
                    var realComponent = interactiveChilds[index]

                    if (realComponent === baseRoot.activeFocusItem
                            && index !== interactiveChildIndex) {
                        interactiveChildIndex = index
                    }
                }
            }
        }
    }

    function updateFocusByIndex() {
        interactiveChilds[interactiveChildIndex].forceActiveFocus(
                    Qt.OtherFocusReason)
    }

    function checkForParentsFocue(item) {
        if (item instanceof MCheckBox || item instanceof MButton) {
            return item.interactiveFocus
        }

        if (item.parent.interactiveFocus) {
            return true
        }

        if (item.parent && item.parent !== root) {
            return checkForParentsFocue(item.parent)
        }
        return false
    }

    function isInteractable(item) {
        var interactableCompos = [Button, TextField, MCheckBox, MButton]
        for (var index in interactableCompos) {
            var realComponent = interactableCompos[index]
            if (item instanceof realComponent) {
                return checkForParentsFocue(item)
            }
        }

        return false
    }

    function lookupRecursive(item) {
        var targets = []
        for (var index in item.children) {
            var childItem = item.children[index]
            if (isInteractable(childItem)) {
                interactiveChilds.push(childItem)
            }
            lookupRecursive(childItem)
        }
    }

    function wrapper() {
        lookupRecursive(root)
        updateFocusByIndex()
    }

    Component.onCompleted: {
        Qt.callLater(wrapper)
    }

    function focusPreviousItem() {
        if (interactiveChildIndex > 0) {
            interactiveChildIndex -= 1
            updateFocusByIndex()
        }
    }

    function focusNextItem() {
        if (interactiveChildIndex < interactiveChilds.length - 1) {
            interactiveChildIndex += 1
            updateFocusByIndex()
        }
    }

    Keys.onUpPressed: focusPreviousItem()
    Keys.onDownPressed: focusNextItem()
    Keys.onTabPressed: event => {

                           interactiveChildIndex += interactiveChildIndex
                           < (interactiveChilds.length - 1) ? +1 : -(interactiveChildIndex)
                           updateFocusByIndex()
                       }

    Keys.onBacktabPressed: {
        focusPreviousItem()
    }

    Keys.onReturnPressed: {
        focusNextItem()
    }

    Keys.onLeftPressed: {
        if (rowNavigation) {
            focusPreviousItem()
        }
    }

    Keys.onRightPressed: {
        if (rowNavigation) {
            focusNextItem()
        }
    }
}
