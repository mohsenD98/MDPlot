import QtQuick 2.0
import QtCharts 2.1
import QtGraphicalEffects 1.0

ChartView {
    id: chartView
    animationOptions: ChartView.NoAnimation
    property bool openGL: true
    property bool openGLSupported: true
    backgroundColor: "transparent"
    property bool areaSeriesEnabled: false
    property alias plot: chartView





    onOpenGLChanged: {
        if (openGLSupported) {
            series("signal 1").useOpenGL = openGL;
        }
    }
    Component.onCompleted: {
        if (!series("signal 1").useOpenGL) {
            openGLSupported = false
            openGL = false
        }
    }

    ValueAxis {
        id: axis_Y
        min: dataSource?dataSource.minViewY:0
        max: dataSource?dataSource.maxViewY:0
    }

    ValueAxis {
        id: axis_X
        min: 0
        max: 1024
    }

    LineSeries {
        id: lineSeries1
        name: "signal 1"
        axisX: axis_X
        axisY: axis_Y
        useOpenGL: chartView.openGL

    }

    Timer {
        id: refreshTimer
        interval: 1 / 10 * 1000 // 60 Hz
        running: true
        repeat: true
        onTriggered: {
            if(areaSeriesEnabled){
                dataSource.update(chartView.series(0).upperSeries);
            }else{
                dataSource.update(chartView.series(0));
            }

        }
    }



    Rectangle {
        id: mask
        anchors.fill: parent

        LinearGradient {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#aaF44336" }
                GradientStop { position: 0.3; color: "#aaFFC107" }
                GradientStop { position: 0.7; color: "#aa4CAF50" }
                GradientStop { position: 1.0; color: "#aa2196F3" }
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: chartView
        }
    }

    function changeSeriesType(type) {
        chartView.removeAllSeries();

        var series1;

        if (type === "line") {
            areaSeriesEnabled = false
            series1 = chartView.createSeries(ChartView.SeriesTypeLine, "signal 1",
                                                 axis_X, axis_Y);
            series1.useOpenGL = chartView.openGL
        } else {
            areaSeriesEnabled = true
            series1 = chartView.createSeries(ChartView.SeriesTypeArea, "signal 1",
                                                 axis_X, axis_Y);
            series1.markerSize = 2;

            series1.useOpenGL = chartView.openGL
        }
    }


    function createAxis(min, max) {
        return Qt.createQmlObject("import QtQuick 2.0; import QtCharts 2.0; ValueAxis { min: "
                                  + min + "; max: " + max + " }", chartView);
    }

    function setAnimations(enabled) {
        if (enabled)
            chartView.animationOptions = ChartView.SeriesAnimations;
        else
            chartView.animationOptions = ChartView.NoAnimation;
    }

    function changeRefreshRate(rate) {
        refreshTimer.interval = 1 / Number(rate) * 1000;
    }
}
