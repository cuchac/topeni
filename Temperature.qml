import QtQuick 2.0

Text {
    function getColor() {
        return "#f19292";
    }

    property int index: 0
    property int value: dataSource.temperatures[index]
    property string prop: "teplota"

    color: getColor()
    id: t_venku
    text: qsTr("%1 °C").arg(value/10);
    font.pixelSize: 18


}

