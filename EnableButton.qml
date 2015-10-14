import QtQuick 2.0
import QtQuick.Controls 1.2

import "."

Button {
    id: button
    width: 150
    checkable: true
    style: Styles.buttonStyle

    property int index: 0

    onEnabledChanged: {
        if (!enabled && checked)
            checked = false
    }

    checked: dataSource.bits[index]

    onCheckedChanged: {
        dataSource.set_bit(index, checked)
    }
}

