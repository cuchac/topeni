import QtQuick 2.0
import QtQuick.Controls 1.2

import "."

Button {
    id: button
    width: 200
    height: 40
    checkable: true
    style: Styles.buttonStyle

    property int index: -1
    property bool value: index >= 0 ? dataSource.bits[index] : false

    checked: value

    onCheckedChanged: {
        if (index >= 0)
            dataSource.set_bit(index, checked)
    }
}

