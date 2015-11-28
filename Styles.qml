pragma Singleton

import QtQuick 2.0
import QtQuick.Controls.Styles 1.0

QtObject {
    property var buttonStyle: Component {
        ButtonStyle {
/*
            background: Rectangle {
                function getColor()
                {
                    var color = bgcolor

                    if (control.checked)
                        color = bgcolor_checked

                    if (control.pressed)
                        return Qt.darker(color, 1.3)

                    if (control.hovered)
                        return Qt.lighter(color, 1.2)

                    return color;
                }

                property color bgcolor: "#CCCCCC"
                property color bgcolor_checked: "#55FF55"

                implicitWidth: 100
                implicitHeight: 25
                border.width: control.activeFocus ? 2 : 1
                border.color: control.disabled ? "#CCCCCC" : "#888888"
                radius: 5
                gradient: Gradient {
                    GradientStop { position: 0 ; color: Qt.lighter(getColor(), 1.2) }
                    GradientStop { position: 1 ; color: Qt.darker(getColor(), 1.2) }
                }
            }
*/
        }
    }
}
