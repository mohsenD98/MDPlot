import QtQuick 2.1
import QtQuick.Layouts 1.0

ColumnLayout {
    property alias openGLButton: openGLButton
    property alias antialiasButton: antialiasButton
    spacing: 8
    Layout.fillHeight: true
    signal animationsEnabled(bool enabled)
    signal seriesTypeChanged(string type)
    signal refreshRateChanged(variant rate);
    signal signalSourceChanged();
    signal antialiasingEnabled(bool enabled)
    signal openGlChanged(bool enabled)

    Text {
        text: "Scope"
        font.pointSize: 18
        color: "white"
    }

    MultiButton {
        id: openGLButton
        text: "OpenGL: "
        items: ["false", "true"]
        currentSelection: 1
        onSelectionChanged: openGlChanged(currentSelection == 1);
    }

    MultiButton {
        text: "Graph: "
        items: ["line", "Area"]
        currentSelection: 0
        onSelectionChanged: seriesTypeChanged(items[currentSelection]);
    }

    MultiButton {
        id: sampleCountButton
        text: "Samples: "
        items: ["100", "250", "500", "1024"]
        currentSelection: 3
        onSelectionChanged: {
            dataSource.sampleRate = selection
            signalSourceChanged();
        }
    }

    MultiButton {
        text: "Refresh rate: "
        items: ["10", "20", "30" , "40", "60"]
        onSelectionChanged: refreshRateChanged(items[currentSelection]);
    }

    MultiButton {
        id: antialiasButton
        text: "Antialias: "
        items: ["OFF", "ON"]
        enabled: true
        currentSelection: 0
        onSelectionChanged: antialiasingEnabled(currentSelection == 1);
    }
}
