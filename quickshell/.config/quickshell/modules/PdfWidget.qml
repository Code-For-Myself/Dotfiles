import Quickshell.Hyprland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../"
import "../theme"

Scope {
    id: pdfWidgetScope
    Colors {
        id: colors
    }

    // Move bibData to root level or reference it correctly
    property var bibData: ({})

    PanelWindow {
        id: panel
        screen: Quickshell.screens[0]

        property bool expanded: false
        property int collapsedWidth: 600
        property int collapsedHeight: 12
        property int expandedWidth: 900
        property int expandedHeight: 700
        property real leftMargin: 200

        anchors {
            bottom: true
            left: true
        }

        margins.left: leftMargin
        focusable: true
        color: "transparent"
        implicitWidth: expanded ? expandedWidth : collapsedWidth
        implicitHeight: expanded ? expandedHeight : collapsedHeight

        function openPopup() {
            collapseTimer.stop();
            expanded = true;
            focusGrab.active = true;
        }

        function closePopup() {
            expanded = false;
            focusGrab.active = false;
        }

        function updateExpanded() {
            if (hoverHandler.hovered) {
                openPopup();
            } else {
                collapseTimer.restart();
            }
        }

        Timer {
            id: collapseTimer
            interval: 450
            onTriggered: {
                if (!hoverHandler.hovered)
                    panel.closePopup();
            }
        }
        Timer {
            id: previewDebounceTimer
            property string targetPath: ""
            interval: 100
            onTriggered: {
                if (targetPath)
                    pdfFinder.requestThumbnail(targetPath);
                else
                    previewImage.source = "";
            }
        }

        HyprlandFocusGrab {
            id: focusGrab
            windows: [panel]
            onCleared: panel.closePopup()
        }

        Rectangle {
            id: background
            anchors.fill: parent
            color: colors.barBg
            border.width: 2
            border.color: panel.expanded ? colors.secondary : "transparent"
            radius: 8

            HoverHandler {
                id: hoverHandler
                onHoveredChanged: {
                    panel.updateExpanded();
                    if (hovered)
                        searchField.forceActiveFocus();
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            visible: panel.expanded
            opacity: panel.expanded ? 1 : 0

            ColumnLayout {
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                spacing: 8

                TextField {
                    id: searchField
                    Layout.preferredWidth: 300
                    placeholderText: "Search PDFs…"
                    color: colors.barBg
                    onActiveFocusChanged: panel.updateExpanded()
                    onTextChanged: pdfFinder.updateFilter(text)
                    Keys.onDownPressed: resultsList.incrementCurrentIndex()
                    Keys.onUpPressed: resultsList.decrementCurrentIndex()
                    Keys.onEscapePressed: panel.closePopup()
                    Keys.onReturnPressed: {
                        const item = pdfFinder.filtered[resultsList.currentIndex];
                        if (item)
                            pdfFinder.openFile(item.path);
                    }
                }

                ListView {
                    id: resultsList
                    Layout.fillHeight: true
                    width: 300
                    clip: true
                    model: pdfFinder.filtered
                    currentIndex: 0

                    onCurrentIndexChanged: pdfFinder.previewCurrent()
                    delegate: Rectangle {
                        id: resultDelegate
                        width: resultsList.width
                        height: 30
                        radius: 4

                        readonly property bool isCurrent: index === resultsList.currentIndex

                        color: mouseAreaList.pressed ? colors.primary : mouseAreaList.containsMouse ? colors.secondary : "transparent"
                        border.width: isCurrent ? 2 : 0
                        border.color: colors.primary

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            // Show title or author if available, fallback to filename
                            text: modelData.title ? modelData.title : modelData.name
                            color: colors.text
                        }

                        MouseArea {
                            id: mouseAreaList
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: resultsList.currentIndex = index
                            onClicked: {
                                resultsList.currentIndex = index;
                                pdfFinder.openFile(modelData.path);
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 6
                color: colors.barBg
                clip: true

                Image {
                    id: previewImage
                    anchors.fill: parent
                    anchors.margins: 4
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    cache: false
                    sourceSize.width: width
                    sourceSize.height: height
                }

                Text {
                    anchors.centerIn: parent
                    visible: previewImage.status !== Image.Ready
                    text: previewImage.status === Image.Loading ? "rendering…" : "no preview"
                    color: colors.secondary
                }
            }
        }
    }

    QtObject {
        id: pdfFinder

        property var allFiles: []
        property var filtered: []
        property string thumbnailDir: Quickshell.env("HOME") + "/.cache/pdf-widget-thumbs"
        property var generatedPaths: ({})
        property string pendingPath: ""

        function hashPath(path) {
            let hash = 5381;
            for (let i = 0; i < path.length; i++) {
                hash = ((hash << 5) + hash + path.charCodeAt(i)) >>> 0;
            }
            return hash.toString(16);
        }

        function thumbnailPathFor(path) {
            return thumbnailDir + "/" + hashPath(path) + ".png";
        }

        function requestThumbnail(path) {
            if (!path)
                return;

            if (generatedPaths[path]) {
                previewImage.source = "file://" + thumbnailPathFor(path);
                return;
            }

            if (thumbProc.running) {
                pendingPath = path;
                return;
            }

            thumbProc.sourcePath = path;
            thumbProc.command = ["pdftoppm", "-png", "-f", "1", "-singlefile", "-scale-to-x", "500", "-scale-to-y", "-1", path, thumbnailDir + "/" + hashPath(path)];
            thumbProc.running = true;
        }

        function previewCurrent() {
            const item = filtered[resultsList.currentIndex];
            previewDebounceTimer.targetPath = item ? item.path : "";
            previewDebounceTimer.restart();
        }

        onFilteredChanged: previewCurrent()

        function openFile(path) {
            if (!path)
                return;
            Quickshell.execDetached(["zathura", path]);
            panel.closePopup();
            searchField.text = "";
        }

        function addFile(name) {
            if (!name || name.length === 0)
                return;

            const meta = bibData[name] || {
                author: "",
                title: "",
                year: ""
            };

            allFiles = allFiles.concat([
                {
                    name: name,
                    path: Quickshell.env("HOME") + "/pdf/" + name,
                    author: meta.author || "",
                    title: meta.title || "",
                    year: meta.year || ""
                }
            ]);
            updateFilter(searchField.text);
        }

        // Called when bibProc finishes loading JSON metadata
        function attachBibData(data) {
            bibData = data;
            let updated = [];
            for (let i = 0; i < allFiles.length; i++) {
                let item = allFiles[i];
                let meta = bibData[item.name] || {};
                item.author = meta.author || "";
                item.title = meta.title || "";
                item.year = meta.year || "";
                updated.push(item);
            }
            allFiles = updated;
            updateFilter(searchField.text);
        }

        function fuzzyScore(query, target) {
            if (!target || target.length === 0)
                return -1;
            query = query.toLowerCase();
            target = target.toLowerCase();
            let qi = 0, score = 0, consecutive = 0;
            for (let ti = 0; ti < target.length && qi < query.length; ti++) {
                if (target[ti] === query[qi]) {
                    score += 1 + consecutive * 2;
                    consecutive++;
                    qi++;
                } else {
                    consecutive = 0;
                }
            }
            return qi === query.length ? score : -1;
        }

        property int listNumber: 27

        function updateFilter(query) {
            if (!query || query.length === 0) {
                filtered = allFiles.slice(0, listNumber);
            } else {
                let scored = [];
                for (const f of allFiles) {
                    const scoreFilename = fuzzyScore(query, f.name);
                    const scoreAuthor = fuzzyScore(query, f.author);
                    const scoreTitle = fuzzyScore(query, f.title);

                    const maxScore = Math.max(scoreFilename, scoreAuthor > 0 ? scoreAuthor * 1.2 : -1, scoreTitle);

                    if (maxScore >= 0) {
                        scored.push(Object.assign({}, f, {
                            score: maxScore
                        }));
                    }
                }
                scored.sort((a, b) => b.score - a.score);
                filtered = scored.slice(0, listNumber);
            }
            resultsList.currentIndex = 0;
        }
    }

    Process {
        id: listProc
        command: ["bash", "-c", "find -L ~/pdf -maxdepth 1 -type f -iname '*.pdf' -printf '%T@ %f\\n' | sort -rn | cut -d' ' -f2-"]
        running: true
        stdout: SplitParser {
            onRead: data => pdfFinder.addFile(data)
        }
    }

    Process {
        command: ["mkdir", "-p", pdfFinder.thumbnailDir]
        running: true
    }

    Process {
        id: jsonProc
        command: ["cat", Quickshell.env("HOME") + "/pdf/library.json"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const parsed = JSON.parse(text);
                    pdfFinder.attachBibData(parsed);
                    console.log("Loaded JSON metadata:", Object.keys(parsed).length, "entries");
                } catch (e) {
                    console.log("Failed to parse library.json:", e);
                }
            }
        }
    }
    Process {
        id: thumbProc
        property string sourcePath: ""

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                pdfFinder.generatedPaths[sourcePath] = true;
                const current = pdfFinder.filtered[resultsList.currentIndex];
                if (current && current.path === sourcePath)
                    previewImage.source = "file://" + pdfFinder.thumbnailPathFor(sourcePath);
            }
            if (pdfFinder.pendingPath) {
                const next = pdfFinder.pendingPath;
                pdfFinder.pendingPath = "";
                pdfFinder.requestThumbnail(next);
            }
        }
    }
}
