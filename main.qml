import QtQuick 2.0
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0

Item {
    id: main
    width: 600
    height: 400

    ControlPanel {
        id: controlPanel
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10

        onSignalSourceChanged: {
            dataSource.generateData();
            scopeView.axisX().max = dataSource.sampleRate;
        }
        onSeriesTypeChanged: scopeView.changeSeriesType(type);
        onRefreshRateChanged: scopeView.changeRefreshRate(rate);
        onAntialiasingEnabled: scopeView.antialiasing = enabled;
        onOpenGlChanged: {
            scopeView.openGL = enabled;
        }
    }


    ScopeView {
        id: scopeView
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: controlPanel.right
        height: main.height

        onOpenGLSupportedChanged: {
            if (!openGLSupported) {
                controlPanel.openGLButton.enabled = false
                controlPanel.openGLButton.currentSelection = 0
            }
        }
    }

}
