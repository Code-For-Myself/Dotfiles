import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../theme"
import "../../"

Scope {
    id: barScope
    Colors {
        id: colors
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: panel
            required property var modelData
            screen: modelData

            property bool expanded: false

            function updateExpanded() {
                if (hoverHandler.hovered || BarState.keepOpen) {
                    collapseTimer.stop();
                    expanded = true;
                } else {
                    collapseTimer.restart();
                }
            }
            Connections {
                target: hoverHandler
                function onHoveredChanged() {
                    panel.updateExpanded();
                }
            }

            Connections {
                target: BarState
                function onKeepOpenChanged() {
                    updateExpanded();
                }
            }

            Timer {
                id: collapseTimer
                interval: 450
                onTriggered: {
                    if (!hoverHandler.hovered && !BarState.keepOpen)
                        panel.expanded = false;
                }
            }
            property int collapsedWidth: 8
            property int expandedWidth: 64

            anchors {
                top: true
                right: true
                bottom: true
            }

            implicitWidth: expanded ? expandedWidth : collapsedWidth
            exclusiveZone: collapsedWidth
            color: "transparent"

            Rectangle {
                id: background
                anchors.fill: parent
                color: colors.barBg

                HoverHandler {
                    id: hoverHandler
                }
            }

            ColumnLayout {
                anchors {
                    fill: parent
                    topMargin: 12
                    bottomMargin: 12
                }
                visible: opacity > 0
                opacity: panel.expanded ? 1 : 0

                Workspaces {
                    Layout.alignment: Qt.AlignHCenter
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                //CurrentWindow {}
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                //SysTray {}

                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 22
                    Clock {
                        Layout.alignment: Qt.AlignHCenter
                    }
                    NetworkModule {
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Bluetooth {
                        Layout.alignment: Qt.AlignHCenter
                    }
                    Battery {
                        Layout.alignment: Qt.AlignHCenter
                    }
                    // Volume {}
                    // SysTray {}
                    // Battery {}
                }
            }
        }
    }
}
