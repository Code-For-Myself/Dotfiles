import QtQuick
import Quickshell
import Quickshell.Hyprland
import "../../"

Item {
    id: root

    property var activeWindow: Hyprland.activeToplevel

    property var desktopEntry: {
        if (!activeWindow || !activeWindow.wayland)
            return null;

        if (!activeWindow.wayland.appId)
            return null;

        return DesktopEntries.heuristicLookup(activeWindow.wayland.appId);
    }

    property string iconPath: desktopEntry ? Quickshell.iconPath(desktopEntry.icon, "") : ""
    property bool windowOnCurrentWorkspace: activeWindow && activeWindow.workspace && activeWindow.workspace.id === Hyprland.focusedWorkspace.id

    implicitWidth: windowRow.width
    implicitHeight: 20

    Row {
        id: windowRow

        spacing: 12

        Image {
            width: 26
            height: 26

            source: root.iconPath
            sourceSize.width: 32
            sourceSize.height: 32

            fillMode: Image.PreserveAspectFit
            smooth: true

            visible: root.windowOnCurrentWorkspace
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter

            color: colors.secondary
            font.pixelSize: 16
            font.bold: true

            text: root.activeWindow ? root.activeWindow.title : "Desktop"
            visible: root.windowOnCurrentWorkspace
        }
    }
}
