import QtQuick 2.0

Rectangle {
    width: 114
    height: 81
    color: "#00000000"
    border.color: "#00000000"
    id: root

    Text {
        id: date
        text: qsTr("26.02.1985")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: root.height / 2.1
    }

    Text {
        id: time
        text: qsTr("10:28:30")
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        verticalAlignment: Text.AlignBottom
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: root.height / 2.1
    }

    Timer {
        id: timer
        interval: 1000
        triggeredOnStart: true
        repeat: true
        running: true

        onTriggered: {
            var d = new Date()
            date.text = "%1.%2.%3".arg(d.getDate()).arg(d.getMonth()+1).arg(d.getFullYear());
            time.text = "%4:%5.%6".arg(d.getHours()).arg(d.getMinutes()).arg(d.getSeconds());
        }
    }

}

