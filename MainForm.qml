import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

//import QuickPlot 1.0

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
            rowSpacing: 0
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
            anchors.leftMargin: 5
            anchors.top: label5.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 6
            columns: 3

            Label {
                id: label1
                text: qsTr("Z TČ")
                font.pixelSize: 14
            }

            ColorRect {
                color: "#FF0000"
            }

            Temperature {
                id: t_cerpadlo
                index: 0
            }

            Label {
                id: label2
                text: qsTr("Do topení")
                font.pixelSize: 14
            }

            ColorRect {
                color: "#00FF00"
            }

            Temperature {
                id: t_topeni
                index: 1
            }

            Label {
                id: label3
                text: qsTr("V akumulačce")
                font.pixelSize: 14
            }

            ColorRect {
                color: "#0000FF"
            }

            Temperature {
                id: t_akomulacka
                index: 2
            }

            Label {
                id: label4
                text: qsTr("Venkovní")
                font.pixelSize: 14
            }

            ColorRect {
                color: "#00FFFF"
            }

            Temperature {
                id: t_venku
                index: 3
            }

            Label {
                id: label6
                text: qsTr("Tlak vody")
                font.pixelSize: 14
            }

            ColorRect {
                color: "#FFFF00"
            }

            Temperature {
                id: t_tlak
                index: 4
                unit: "bar"
            }

            Label {
                id: label7
                text: qsTr("Aktuální spotřeba")
                font.pixelSize: 14
            }

            ColorRect {
                color: "#ff00ff"
            }

            Temperature {
                id: t_tlak1
                index: 5
                unit: 'W'
                divider: 1
            }
        }

        Label {
            id: label5
            text: qsTr("Teploty")
            anchors.left: parent.left
            anchors.leftMargin: 50
            font.bold: true
            font.pointSize: 21
            anchors.top: parent.top
            anchors.topMargin: 5
        }

        Label {
            id: label8
            x: 98
            y: 50
            color: "#ea430c"
            text: qsTr("HDO :-(")
            font.bold: true
            font.pixelSize: 20
            visible: dataSource.bits[9]
        }

        Clock {
            id: clock1
            x: 173
            width: 111
            height: 29
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.right: parent.right
            anchors.rightMargin: 5
        }
    }

    EnableButton {
        id: automat
        x: 8
        y: 8
        height: 45
        text: qsTr("Plná automatika")
        index: 6
    }

    EnableButton {
        id: radiatory
        x: 8
        y: 134
        text: qsTr("Topit do topení")
        enabled: !automat.checked
        index: 3
    }
    EnableButton {
        id: podlahy
        x: 8
        y: 88
        text: qsTr("Topit akumulačkou")
        enabled: !automat.checked
        index: 5
    }
    EnableButton {
        id: button2
        x: 8
        y: 180
        text: qsTr("Nahřívat akumulačku")
        enabled: !automat.checked
        index: 4
    }

    EnableButton {
        id: button1
        x: 512
        y: 11
        text: qsTr("Čerpadlo podlahy")
        enabled: !automat.checked && !temperovani.checked
        index: 2
    }

    EnableButton {
        id: button3
        x: 512
        y: 55
        text: qsTr("Čerpadlo topení")
        enabled: !automat.checked && !temperovani.checked
        index: 1
    }

    EnableButton {
        id: button4
        x: 512
        y: 99
        text: qsTr("Čerpadlo TČ")
        enabled: !automat.checked && !temperovani.checked
        index: 0
    }

    MouseArea {
        id: mouseArea1
        x: -12
        y: 226
        width: 732
        height: 195

        onClicked: {
            history.state = ''
        }

        Plot {
            temperatures: dataSource.temperatures

            Component.onCompleted: {
                dataSource.measured.connect(measured)

                // Fill history
                fillData(dataSource.get_temperatures_history())
            }
        }
    }

    EnableButton {
        id: temperovani
        x: 512
        y: 180
        text: qsTr("Temperování na %1 - %2 °C").arg(dataSource.variables[0]/10).arg(dataSource.variables[1]/10)
        enabled: !automat.checked
        index: 8
    }
    History {
        id: history
        x: 8
        y: 8
        z: 3

        function update() {
            if (state == '') {
                var data = dataSource.get_date_history(cur_date)
                fillData(data[0])
                setStats(data[1])
            }
        }

        onCur_dateChanged: update()

        onStateChanged: {
            setToday()
            update()
        }
    }

    EnableButton {
        id: button5
        x: 511
        y: 145
        width: 201
        height: 29
        text: qsTr("Nautila")
        enabled: !automat.checked && !temperovani.checked
        index: 10
    }

    Rectangle {
        id: rectangle
        x: 143
        y: 56
        width: 31
        height: 27
        color: "#cadefe"

        Text {
            id: element
            text: dataSource.variables[2]
            anchors.fill: parent
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 20
        }
    }

    Button {
        id: teplota_minus
        x: 108
        y: 55
        width: 34
        height: 31
        text: qsTr("-")
        enabled: automat.checked
        onClicked: dataSource.set_variable(2, dataSource.variables[2]-1)
    }

    Button {
        id: teplota_plus
        x: 174
        y: 55
        width: 34
        height: 31
        text: qsTr("+")
        enabled: automat.checked
        onClicked: dataSource.set_variable(2, dataSource.variables[2]+1)
    }

    Text {
        id: element1
        x: 8
        y: 61
        text: qsTr("Doladění teploty")
        font.pixelSize: 13
    }
}








