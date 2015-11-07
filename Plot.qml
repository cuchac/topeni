import QtQuick 2.0

import QuickPlot 1.0

PlotArea {
    id: plotArea
    hasXTicks: false

    property variant temperatures: null
    property int points: 300

    function measured() {
        //            console.error('Measured')

        for (var index in lines)
        {
            //                console.error('Temp changed', index, temperatures[index])
            lines[index].appendDataPoint(temperatures[index]/10);
        }
    }

    function clean()
    {
        for (var point = 0; point < points; point++)
        {
            for (var index in lines)
                lines[index].appendDataPoint(-100);
        }
    }

    function fillData(temp_history)
    {
        for (var index_history in temp_history)
        {
            var row = temp_history[index_history]
            for (var index in lines)
                lines[index].appendDataPoint(row[index]/10);
        }
    }

    yScaleEngine: FixedScaleEngine {
        max: 60
        min: 0
    }

    items: [
        ScrollingCurve {
            id: temperature_0
            numPoints: points
            color: "#FF0000"
        },
        ScrollingCurve {
            id: temperature_1
            numPoints: points
            color: "#00FF00"
        },
        ScrollingCurve {
            id: temperature_2
            numPoints: points
            color: "#0000FF"
        },
        ScrollingCurve {
            id: temperature_3
            numPoints: points
            color: "#00FFFF"
        },
        ScrollingCurve {
            id: temperature_4
            numPoints: points
            color: "#FFFF00"
        }
    ]

    property variant lines: [temperature_0, temperature_1, temperature_2, temperature_3, temperature_4]
    anchors.fill: parent
    anchors.top: parent.top
    anchors.left: parent.left
}

