import Quickshell
import "./modules/bar"
import "./modules"

Scope {
    id: root

    // Top Bar Module
    Bar {}

    // Standalone Popups & Overlays
    Volume {}
    PdfWidget {}
    NetworkModule {}
}
