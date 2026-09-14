import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Item {
    id: root

    implicitWidth: trayRow.implicitWidth
    implicitHeight: trayRow.implicitHeight

    Row {
        id: trayRow
        spacing: 8

        Repeater {
            model: SystemTray.items

            delegate: Image {
                width: 20
                height: 20

                source: modelData.icon
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent

                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate()
                        } else if (mouse.button === Qt.RightButton) {
                            modelData.openMenu()
                        }
                    }
                }
            }
        }
    }
}
