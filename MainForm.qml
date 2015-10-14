import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Item {
    width: 720
    height: 400

    Rectangle {
        id: rectangle1
        x: 214
        y: 8
        width: 292
        height: 240
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
        y: 162
        text: qsTr("Topit do topení")
//        enabled: cerpadlo.checked
        index: 3
    }

    EnableButton {
        id: cerpadlo
        x: 8
        y: 57
        text: qsTr("Zapnuté čerpadlo")
        enabled: !automat.checked
    }
    EnableButton {
        id: podlahy
        x: 8
        y: 116
        text: qsTr("Topit akumulačkou")
//        enabled: cerpadlo.checked
        index: 5
    }
    EnableButton {
        id: button2
        x: 8
        y: 208
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
}
