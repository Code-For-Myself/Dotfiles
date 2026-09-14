import QtQuick
import Quickshell
import Quickshell.Networking
import "../../"
import "../../theme"

Item {
    id: root
    property var wifiDevice: Networking.devices.values.find(device => device.type === DeviceType.Wifi)
    property var wifiNetwork: wifiDevice ? wifiDevice.networks.values.find(network => network.connected) : null
    property bool connected: wifiDevice ? wifiDevice.connected : true
    property real signalStrength: wifiNetwork ? wifiNetwork.signalStrength : 0

    property bool iconHovered: false
    property bool popupHovered: false

    implicitWidth: 20
    implicitHeight: 20

    MaterialIcon {
        id: networkIcon
        anchors.fill: parent

        icon: {
            if (!root.connected)
                return "signal_wifi_off";

            if (root.signalStrength >= 0.8)
                return "network_wifi";

            if (root.signalStrength >= 0.6)
                return "network_wifi_3_bar";

            if (root.signalStrength >= 0.4)
                return "network_wifi_2_bar";

            return "network_wifi_1_bar";
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

        onClicked: {
            popup.visible = false;
            networkListPopup.visible = !networkListPopup.visible;
        }
    }

    PopupWindow {
        id: popup

        visible: false

        implicitWidth: 200
        implicitHeight: 80
        color: "transparent"

        anchor.item: networkIcon
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
                text: root.connected ? wifiNetwork.name + "\n" + Math.round(root.signalStrength * 100) + "%" : "Disconnected"
            }
        }
    }

    PopupWindow {
        id: networkListPopup

        visible: false

        implicitWidth: 300
        implicitHeight: 400
        color: "transparent"
        anchor.item: networkIcon
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

                Text {
                    text: "Wi-Fi Networks"
                    color: colors.secondary
                    font.pixelSize: 18
                }

                Repeater {
                    model: wifiDevice ? wifiDevice.networks : null

                    Rectangle {
                        width: parent.width
                        height: 40
                        radius: 10

                        color: mouseArea.pressed ? colors.primary : modelData.connected ? colors.secondary : "transparent"

                        Text {
                            anchors.centerIn: parent

                            text: modelData.name
                            color: colors.text
                            font.pixelSize: 15
                        }

                        MouseArea {
                            id: mouseArea
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

    Timer {
        id: hideTimer

        interval: 150
        repeat: false

        onTriggered: {
            if (!root.iconHovered && !root.popupHovered)
                popup.visible = false;
        }
    }
    property bool anyPopupOpen: popup.visible || networkListPopup.visible

    onAnyPopupOpenChanged: {
        if (anyPopupOpen)
            BarState.acquire();
        else
            BarState.release();
    }
}
