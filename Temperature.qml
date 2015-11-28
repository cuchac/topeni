import QtQuick 2.0

Text {
    function getColor() {
        return "#f19292";
    }

    property int index: 0
    property int value: dataSource.temperatures[index]
    property string unit: "°C"
    property int divider: 10

    color: getColor()
    id: t_venku
    text: qsTr("%1 %2").arg(value/divider).arg(unit);
    font.pixelSize: 18
}

