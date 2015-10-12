import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import DataSource 1.0

ApplicationWindow {
    title: qsTr("Hello World")
    width: 720
    height: 400
    visible: true

    MainForm {
        anchors.fill: parent
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    DataSource {
        id: dataSource
    }
}
