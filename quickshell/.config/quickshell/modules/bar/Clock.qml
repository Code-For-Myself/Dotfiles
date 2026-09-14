import QtQuick
import "../../theme"
import "../../services"
Text {
    text: Time.timeString
    color: colors.secondary
    font.pixelSize: 16
    font.bold: true
}
