import QtQuick 2.0

import QuickPlot 1.0
import QtQuick.Controls 1.2

Rectangle {
    id: history
    width: 704
    height: 384
    radius: 12
    border.width: 2
    states: [
        State {
            name: "hidden"

            PropertyChanges {
                target: history
                visible: false
            }
        }
    ]

    state: 'hidden'

    property date cur_date: new Date()

    function fillData(data)
    {
        plot1.points = Math.max(data.length, 1)
        return plot1.fillData(data);
    }

    function setStats(stats)
    {
        duration.text = stats['duration'];
        power.text = "%1 kWh / %2 Kč".arg(stats['power']).arg(stats['power']*2.3)
    }

    function setToday()
    {
        cur_date = new Date();
    }

    Button {
        id: close
        x: 626
        y: 8
        width: 70
        height: 28
        text: qsTr("Zavřít")

        onClicked: history.state = 'hidden'
    }

    Button {
        id: prev
        x: 8
        y: 6
        text: qsTr("Předchozí")

        onClicked: {
            var date = cur_date;
            date.setDate(date.getDate() - 1)
            cur_date = date
        }
    }

    Button {
        id: next
        x: 216
        y: 6
        text: qsTr("Následující")

        onClicked: {
            var date = cur_date;
            date.setDate(date.getDate() + 1)
            cur_date = date
        }
    }

    Slider {
        id: zoom
        x: 359
        y: 36
        width: 214
        height: 22
        updateValueWhileDragging: false
        stepSize: 0.1
        maximumValue: 10
        minimumValue: 1
        value: 1
    }

    Text {
        id: text1
        x: 435
        y: 4
        text: qsTr("Zoom")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
    }

    Text {
        id: text2
        x: 116
        y: 4
        text: qsTr("Datum")
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
    }

    Label {
        id: label1
        x: 47
        y: 31
        width: 207
        height: 31
        text: cur_date.toDateString()
        font.bold: true
        font.pointSize: 18
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Flickable {
        id: flickable1
        x: -52
        y: -24
        anchors.rightMargin: 3
        anchors.leftMargin: 3
        clip: true
        contentHeight: height
        contentWidth: width * zoom.value
        anchors.topMargin: 90
        anchors.fill: parent

        Plot {
            id: plot1
            anchors.fill: parent
        }
    }

    Label {
        id: label2
        x: 8
        y: 63
        text: qsTr("Čerpadlo zaplé")
        font.pointSize: 19
    }

    Label {
        id: duration
        x: 185
        y: 63
        text: qsTr("1:25:15")
        font.bold: true
        font.pointSize: 19
    }

    Label {
        id: label3
        x: 320
        y: 63
        text: qsTr("Spotřeba")
        font.pointSize: 19
    }

    Label {
        id: power
        x: 430
        y: 64
        width: 266
        height: 28
        text: qsTr("1:25:15")
        font.pointSize: 19
        font.bold: true
    }
}

