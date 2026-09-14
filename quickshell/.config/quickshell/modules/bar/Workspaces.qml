import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import "../../theme"

ColumnLayout {
    spacing: 6

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            required property var modelData

            implicitWidth: 24
            implicitHeight: 24
            radius: 4

            color: mouseArea.pressed ? colors.secondary : mouseArea.containsMouse ? colors.primary : modelData.focused ? colors.secondary : "transparent"

            Text {
                anchors.centerIn: parent

                text: modelData.id

                color: modelData.focused ? colors.barBg : colors.secondary

                font.bold: modelData.focused
                font.pixelSize: 11
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    Hyprland.dispatch(`hl.dsp.focus({ workspace = ${modelData.id} })`);
                }
            }
        }
    }
}
