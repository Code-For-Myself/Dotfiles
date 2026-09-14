import QtQuick
import Quickshell
import Quickshell.Services.UPower
import "../../"

Item {
    id: root

    property var battery: UPower.displayDevice

    property real percentage: battery ? battery.percentage : 0

    property bool charging: battery ? battery.state === UPowerDeviceState.Charging : false

    property bool iconHovered: false
    property bool popupHovered: false

    implicitWidth: 20
    implicitHeight: 20

    MaterialIcon {
        id: batteryIcon

        anchors.fill: parent

        icon: {
            if (root.charging)
                return "battery_charging_full";

            if (root.percentage >= 0.90)
                return "battery_full";

            if (root.percentage >= 0.60)
                return "battery_5_bar";

            if (root.percentage >= 0.40)
                return "battery_4_bar";

            if (root.percentage >= 0.20)
                return "battery_2_bar";

            return "battery_1_bar";
        }

        color: colors.secondary
        size: 20
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        z: 10

        onEntered: {
            root.iconHovered = true;
            hideTimer.stop();
            popup.visible = true;
        }

        onExited: {
            root.iconHovered = false;
            hideTimer.restart();
        }
    }

    PopupWindow {
        id: popup

        visible: false

        implicitWidth: 200
        implicitHeight: 80

        color: "transparent"

        anchor.item: batteryIcon
        anchor.gravity: Edges.Left | Edges.Bottom
        anchor.margins.top: 30

        Rectangle {
            anchors.fill: parent

            color: colors.barBg
            radius: 8

            border.width: 2
            border.color: colors.text

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    root.popupHovered = true;
                    hideTimer.stop();
                }

                onExited: {
                    root.popupHovered = false;
                    hideTimer.restart();
                }
            }

            Text {
                anchors.centerIn: parent

                color: colors.secondary
                font.pixelSize: 14
                font.bold: true

                text: {
                    if (!root.battery)
                        return "Battery unavailable";

                    return Math.round(root.percentage * 100) + "%" + (root.charging ? "\nCharging" : "\nNot charging");
                }
            }
        }
    }

    Timer {
        id: hideTimer

        interval: 150
        repeat: false

        onTriggered: {
            if (!root.iconHovered && !root.popupHovered)
                popup.visible = false;
        }
    }
}
