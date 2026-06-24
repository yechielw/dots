import QtQuick
import qs.Common
import qs.Widgets

StyledRect {
    id: root

    property string deviceId: ""

    signal close
    signal sendSms(string phoneNumber, string message)
    signal launchApp

    height: contentColumn.implicitHeight + Theme.spacingM * 2
    radius: Theme.cornerRadius
    color: Theme.surfaceContainerHighest

    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: Theme.spacingM
        spacing: Theme.spacingS

        Row {
            width: parent.width

            StyledText {
                text: I18n.tr("Send SMS", "KDE Connect SMS dialog title")
                font.pixelSize: Theme.fontSizeMedium
                font.weight: Font.Medium
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }

            Item {
                width: parent.width - closeBtn.width - 60
                height: 1
            }

            Rectangle {
                id: closeBtn
                width: 28
                height: 28
                radius: 14
                color: closeArea.containsMouse ? Theme.errorHover : "transparent"

                DankIcon {
                    anchors.centerIn: parent
                    name: "close"
                    size: Theme.iconSize - 6
                    color: closeArea.containsMouse ? Theme.error : Theme.surfaceVariantText
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }
        }

        DankTextField {
            id: phoneInput
            width: parent.width
            placeholderText: I18n.tr("Phone number", "KDE Connect SMS phone input placeholder") + "..."
        }

        DankTextField {
            id: messageInput
            width: parent.width
            placeholderText: I18n.tr("Message", "KDE Connect SMS message input placeholder") + "..."
        }

        Row {
            spacing: Theme.spacingS

            DankButton {
                text: I18n.tr("Send", "KDE Connect SMS send button")
                iconName: "send"
                enabled: phoneInput.text.length > 0 && messageInput.text.length > 0
                onClicked: {
                    root.sendSms(phoneInput.text, messageInput.text);
                    phoneInput.text = "";
                    messageInput.text = "";
                }
            }

            DankButton {
                text: I18n.tr("Open App", "KDE Connect open SMS app button")
                iconName: "open_in_new"
                onClicked: root.launchApp()
            }
        }
    }
}
