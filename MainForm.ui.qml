import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

import "."

Item {
    width: 720
    height: 400

    Rectangle {
        id: rectangle1
        x: 164
        y: 8
        width: 266
        height: 199
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
                text: qsTr("Za tepelným čerpadlem")
                font.pointSize: 14
            }

            Temperature {
                id: t_cerpadlo
            }

            Label {
                id: label2
                text: qsTr("Do topení")
                font.pointSize: 14
            }

            Temperature {
                id: t_topeni
            }

            Label {
                id: label3
                text: qsTr("V akumulačce")
                font.pointSize: 14
            }

            Temperature {
                id: t_akomulacka
            }

            Label {
                id: label4
                text: qsTr("Venkovní")
                font.pointSize: 14
            }

            Temperature {
                id: t_venku
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

    Button {
        id: automat
        x: 8
        y: 8
        width: 150
        height: 45
        text: qsTr("Plná automatika")
        checkable: true
        style: Styles.buttonStyle
    }

    Button {
        id: radiatory
        x: 8
        y: 145
        width: 150
        height: 28
        text: qsTr("Topení do radiátorů")
        enabled: cerpadlo.checked
        checkable: true
        style: Styles.buttonStyle
    }

    Button {
        id: cerpadlo
        x: 8
        y: 75
        width: 150
        height: 28
        text: qsTr("Zapnuté čerpadlo")
        enabled: !automat.checked
        checkable: true
        style: Styles.buttonStyle
    }
    Button {
        id: podlahy
        x: 8
        y: 111
        width: 150
        height: 28
        text: qsTr("Topení do podlah")
        enabled: cerpadlo.checked
        checkable: true
        style: Styles.buttonStyle
    }
    Button {
        id: button2
        x: 8
        y: 179
        width: 150
        height: 28
        text: qsTr("Topení do akumulačky")
        enabled: cerpadlo.checked
        checkable: true
        style: Styles.buttonStyle
    }
}
