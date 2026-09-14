import QtQuick
import Quickshell
import Quickshell.Bluetooth
import "../../"

Item {
    id: root

    property var bluetoothAdapter: Bluetooth.defaultAdapter

    property var connectedDevice: bluetoothAdapter ? bluetoothAdapter.devices.values.find(device => device.connected) : null

    property bool enabled: bluetoothAdapter ? bluetoothAdapter.enabled : false

    property bool iconHovered: false
    property bool popupHovered: false

    implicitWidth: 20
    implicitHeight: 20

    // ─────────────────────────────
    // Bluetooth icon
    // ─────────────────────────────

    MaterialIcon {
        id: bluetoothIcon
        anchors.fill: parent

        icon: root.enabled ? "bluetooth" : "bluetooth_disabled"

        color: colors.secondary
        size: 20
    }

    // ─────────────────────────────
    // Icon interaction
    // ─────────────────────────────

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

        onClicked: {
            popup.visible = false;
            bluetoothListPopup.visible = !bluetoothListPopup.visible;
        }
    }

    // ─────────────────────────────
    // Hover popup
    // ─────────────────────────────

    PopupWindow {
        id: popup

        visible: false

        implicitWidth: 200
        implicitHeight: 80

        color: "transparent"

        anchor.item: bluetoothIcon
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
                    if (!root.enabled)
                        return "Bluetooth Disabled";

                    if (!root.connectedDevice)
                        return "No device connected";

                    if (root.connectedDevice.batteryAvailable) {
                        return root.connectedDevice.name + "\n" + Math.round(root.connectedDevice.battery * 100) + "%";
                    }

                    return root.connectedDevice.name + "\n" + "Battery unavailable";
                }
            }
        }
    }

    PopupWindow {
        id: bluetoothListPopup

        visible: false

        implicitWidth: 300
        implicitHeight: 400

        color: "transparent"

        anchor.item: bluetoothIcon
        anchor.gravity: Edges.Left | Edges.Bottom
        anchor.margins.top: 30

        grabFocus: true

        Rectangle {
            anchors.fill: parent

            color: colors.barBg
            radius: 10

            border.width: 2
            border.color: colors.text

            Column {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                // ─────────────────
                // Title
                // ─────────────────

                Text {
                    text: "Bluetooth Devices"

                    color: colors.secondary
                    font.pixelSize: 18
                }

                Rectangle {
                    width: parent.width
                    height: 40

                    radius: 10

                    color: scanMouseArea.pressed ? colors.primary : scanMouseArea.containsMouse ? colors.secondary : "transparent"

                    Text {
                        anchors.centerIn: parent

                        text: bluetoothAdapter && bluetoothAdapter.discovering ? "Scanning..." : "Scan"

                        color: colors.text
                        font.pixelSize: 15
                    }

                    MouseArea {
                        id: scanMouseArea
                        hoverEnabled: true

                        anchors.fill: parent

                        onClicked: {
                            if (bluetoothAdapter) {
                                bluetoothAdapter.discovering = true;
                                scanTimer.restart();
                            }
                        }
                    }
                }

                // ─────────────────
                // Device list
                // ─────────────────

                Repeater {
                    model: bluetoothAdapter ? bluetoothAdapter.devices : null

                    Rectangle {
                        width: parent.width
                        height: 40

                        radius: 10

                        color: mouseArea.pressed ? colors.primary : mouseArea.containsMouse ? colors.secondary : modelData.connected ? colors.secondary : "transparent"

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            anchors.verticalCenter: parent.verticalCenter

                            text: modelData.name

                            color: colors.text
                            font.pixelSize: 15
                        }

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 10
                            anchors.verticalCenter: parent.verticalCenter

                            text: modelData.batteryAvailable ? Math.round(modelData.battery * 100) + "%" : ""

                            color: colors.text
                            font.pixelSize: 13
                        }

                        MouseArea {
                            id: mouseArea
                            hoverEnabled: true

                            anchors.fill: parent

                            onClicked: {
                                if (modelData.connected) {
                                    modelData.disconnect();
                                } else {
                                    modelData.connect();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ─────────────────────────────
    // Scan timer
    // ─────────────────────────────

    Timer {
        id: scanTimer

        interval: 10000
        repeat: false

        onTriggered: {
            if (bluetoothAdapter)
                bluetoothAdapter.discovering = false;
        }
    }

    // ─────────────────────────────
    // Hover popup timer
    // ─────────────────────────────

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
