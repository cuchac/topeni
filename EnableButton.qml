import QtQuick 2.0
import QtQuick.Controls 1.3

import "."

Button {
    id: button
    width: 150
    checkable: true
    style: Styles.buttonStyle

    onEnabledChanged: {
        if (!enabled && checked)
            checked = false
    }
}

