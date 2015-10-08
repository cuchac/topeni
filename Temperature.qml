import QtQuick 2.0

Text {
    function getColor() {
        return "#f19292";
    }

    property int value: 10

    color: getColor()
    id: t_venku
    text: qsTr("%1 °C").arg(value);
    font.pixelSize: 18
}

