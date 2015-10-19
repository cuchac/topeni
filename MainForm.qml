import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import QuickPlot 1.0

Item {
    width: 720
    height: 400

    Rectangle {
        id: rectangle1
        x: 214
        y: 8
        width: 292
        height: 212
        color: "#fff3e9"

        GridLayout {
            id: gridLayout1
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.top: label5.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 15
            columns: 2

            Label {
                id: label1
                text: qsTr("Z tepelného čerpadla")
                font.pointSize: 14
            }

            Temperature {
                id: t_cerpadlo
                index: 0
            }

            Label {
                id: label2
                text: qsTr("Do topení")
                font.pointSize: 14
            }

            Temperature {
                id: t_topeni
                index: 1
            }

            Label {
                id: label3
                text: qsTr("V akumulačce")
                font.pointSize: 14
            }

            Temperature {
                id: t_akomulacka
                index: 2
            }

            Label {
                id: label4
                text: qsTr("Venkovní")
                font.pointSize: 14
            }

            Temperature {
                id: t_venku
                index: 3
            }

            Label {
                id: label6
                text: qsTr("Tlak vody")
                font.pointSize: 14
            }

            Temperature {
                id: t_tlak
                index: 4
            }
        }

        Label {
            id: label5
            x: 50
            text: qsTr("Teploty")
            font.bold: true
            font.pointSize: 21
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5
        }
    }

    EnableButton {
        id: automat
        x: 8
        y: 8
        height: 45
        text: qsTr("Plná automatika")
    }

    EnableButton {
        id: radiatory
        x: 8
        y: 134
        text: qsTr("Topit do topení")
//        enabled: cerpadlo.checked
        index: 3
    }

    EnableButton {
        id: cerpadlo
        x: 512
        y: 180
        text: qsTr("Zapnuté čerpadlo")
        enabled: !automat.checked
    }
    EnableButton {
        id: podlahy
        x: 8
        y: 88
        text: qsTr("Topit akumulačkou")
        //        enabled: cerpadlo.checked
        index: 5
    }
    EnableButton {
        id: button2
        x: 8
        y: 180
        text: qsTr("Nahřívat akumulačku")
//        enabled: cerpadlo.checked
        index: 4
    }

    EnableButton {
        id: button1
        x: 512
        y: 11
        text: qsTr("Čerpadlo podlahy")
        index: 2
    }

    EnableButton {
        id: button3
        x: 512
        y: 57
        text: qsTr("Čerpadlo topení")
        index: 1
    }

    EnableButton {
        id: button4
        x: 512
        y: 103
        text: qsTr("Čerpadlo TČ")
        index: 0
    }

    PlotArea {
        id: plotArea
        x: -12
        y: 226
        width: 732
        height: 195
        hasXTicks: false

        property variant temperatures: dataSource.temperatures

        function measured() {
//            console.error('Measured')

            for (var index in lines)
            {
//                console.error('Temp changed', index, dataSource.temperatures[index])
                lines[index].appendDataPoint(dataSource.temperatures[index]/10);
            }
        }

        Component.onCompleted: {
            dataSource.measured.connect(measured)

            // Fill history
            var temp_history = dataSource.get_temperatures_history()
            for (var index_history in temp_history)
            {
                var row = temp_history[index_history]
                for (var index in row)
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
                numPoints: 300
                color: "#FF0000"
            },
            ScrollingCurve {
                id: temperature_1
                numPoints: 300
                color: "#00FF00"
            },
            ScrollingCurve {
                id: temperature_2
                numPoints: 300
                color: "#0000FF"
            },
            ScrollingCurve {
                id: temperature_3
                numPoints: 300
                color: "#00FFFF"
            },
            ScrollingCurve {
                id: temperature_4
                numPoints: 300
                color: "#FFFF00"
            }
        ]

        property variant lines: [temperature_0, temperature_1, temperature_2, temperature_3, temperature_4]
    }
}
