import QtQuick 2.0

import QuickPlot 1.0
import QtQuick.Controls 1.3

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
        x: 17
        y: 39
        text: qsTr("Předchozí")

        onClicked: {
            var date = cur_date;
            date.setDate(date.getDate() - 1)
            cur_date = date
        }
    }

    Button {
        id: next
        x: 360
        y: 39
        text: qsTr("Následující")

        onClicked: {
            var date = cur_date;
            date.setDate(date.getDate() + 1)
            cur_date = date
        }
    }

    Slider {
        id: zoom
        x: 486
        y: 38
        updateValueWhileDragging: false
        stepSize: 0.1
        maximumValue: 10
        minimumValue: 1
        value: 1
    }

    Text {
        id: text1
        x: 551
        y: 8
        text: qsTr("Zoom")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 24
    }

    Text {
        id: text2
        x: 186
        y: 6
        text: qsTr("Datum")
        font.pixelSize: 24
        horizontalAlignment: Text.AlignHCenter
    }

    Label {
        id: label1
        x: 155
        y: 32
        width: 144
        height: 31
        text: cur_date.toDateString()
        font.bold: true
        font.pointSize: 20
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
        x: 17
        y: 65
        text: qsTr("Cerpadlo zaplé")
        font.pointSize: 19
    }

    Label {
        id: duration
        x: 165
        y: 65
        text: qsTr("1:25:15")
        font.bold: true
        font.pointSize: 19
    }
}

