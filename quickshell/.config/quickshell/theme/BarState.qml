pragma Singleton
import QtQuick

QtObject {
    id: root

    property int holders: 0
    readonly property bool keepOpen: holders > 0

    function acquire() {
        root.holders += 1;
    }
    function release() {
        root.holders = Math.max(0, root.holders - 1);
    }
}
