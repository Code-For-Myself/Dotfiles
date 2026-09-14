pragma Singleton
import QtQuick

QtObject {
    id: root

    property date currentTime: new Date()
    
    // 24-hour time format (22:50)
    property string timeString: Qt.formatDateTime(currentTime, "hh:mm")
    property string dateString: Qt.formatDateTime(currentTime, "ddd MMM d")

    property Timer _timer: Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }
}
