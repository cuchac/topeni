import QtQuick 2.4
import QtQuick.Controls 1.3

import DataSource 1.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 720
    height: 400
    visible: true
    visibility: "FullScreen"

    MainForm {
        anchors.fill: parent
    }

    onClosing: dataSource.stop()

    DataSource {
        id: dataSource
    }


}
