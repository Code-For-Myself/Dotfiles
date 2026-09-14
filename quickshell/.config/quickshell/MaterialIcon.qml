import QtQuick

Text {
    id: root

    property string icon: ""
    property real size: 20
    property bool fill: false
    property int weight: 400
    property int grade: 0
    property real opticalSize: size
    property color iconColor: "white"

    text: icon
    color: iconColor

    font.family: "Material Symbols Rounded"
    font.pixelSize: size
    font.features: {
        "liga": 1
    }
    font.preferShaping: true
    font.variableAxes: {
        "FILL": fill ? 1 : 0,
        "wght": weight,
        "GRAD": grade,
        "opsz": opticalSize
    }

    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
