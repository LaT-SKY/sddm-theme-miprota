import QtQuick 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920; height: 1080
    color: "#121212"

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: sessionCtrl.currentIndex
    property string errorMessage: ""

    TextConstants { id: t }

    // 1 ── Backgrounds ──
    Repeater {
        model: screenModel
        Item {
            x: geometry.x; y: geometry.y
            width: geometry.width; height: geometry.height

            Image {
                id: bgSource
                anchors.fill: parent
                source: config.background
                fillMode: Image.PreserveAspectCrop
                visible: false
                onStatusChanged: {
                    if (status == Image.Error && source != "")
                        source = ""
                }
            }

            FastBlur {
                anchors.fill: parent; source: bgSource; radius: 48
            }

            Rectangle {
                anchors.fill: parent; color: "#000000"; opacity: 0.25
            }
        }
    }

    // 2 ── Session selector ──
    Item {
        id: sessionCtrl
        anchors.top: parent.top; anchors.topMargin: 40
        anchors.left: parent.left; anchors.leftMargin: 40
        width: sessionPill.width; height: sessionPill.height
        property int currentIndex: sessionModel.lastIndex

        ListView {
            id: sessionList; model: sessionModel; visible: false
            width: 0; height: 0; currentIndex: sessionCtrl.currentIndex
            delegate: Text { text: model.name }
        }

        Rectangle {
            id: sessionPill
            width: sessionLabel.width + arrowTxt.width + 32
            height: 40; radius: 20
            color: sessionMouse.pressed ? "#1FFFFFFF" : "#0DFFFFFF"
            border.width: 1; border.color: "#1FFFFFFF"

            Row {
                anchors.centerIn: parent; spacing: 6
                Text {
                    id: sessionLabel
                    text: sessionList.currentItem ? sessionList.currentItem.text : "Session"
                    font.pixelSize: 13; font.family: "Google Sans Flex"; color: "#E6E1E5"
                }
                Text {
                    id: arrowTxt; text: "▾"
                    font.pixelSize: 10; font.family: "Google Sans Flex"; color: "#938F99"
                }
            }

            MouseArea {
                id: sessionMouse; anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: sessionMenu.visible = !sessionMenu.visible
            }
        }

        Rectangle {
            id: sessionMenu; visible: false
            anchors.top: sessionPill.bottom; anchors.topMargin: 8
            anchors.left: sessionPill.left
            width: Math.max(sessionPill.width + 40, 180)
            height: menuCol.height + 16; radius: 16
            color: "#2B2930"; border.width: 1; border.color: "#1FFFFFFF"; z: 10

            Column {
                id: menuCol
                anchors.top: parent.top; anchors.topMargin: 8
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 16; spacing: 2

                Repeater {
                    model: sessionModel
                    Rectangle {
                        width: menuCol.width; height: 36; radius: 10
                        color: itemHover.containsMouse ? "#1FFFFFFF" : "transparent"
                        Text {
                            anchors.centerIn: parent; text: model.name
                            font.pixelSize: 13; font.family: "Google Sans Flex"
                            color: sessionCtrl.currentIndex === index ? "#D0BCFF" : "#E6E1E5"
                            font.bold: sessionCtrl.currentIndex === index
                        }
                        MouseArea {
                            id: itemHover; anchors.fill: parent
                            hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                sessionCtrl.currentIndex = index
                                sessionMenu.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    // 3 ── Time & Date ──
    Column {
        anchors.top: parent.top; anchors.topMargin: 80
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(new Date(), "HH:mm")
            font.pixelSize: 72; font.bold: true; font.family: "Google Sans Flex"
            color: "#FFFFFF"; opacity: 0.95
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDateTime(new Date(), "M月d日 ddd")
            font.pixelSize: 18; font.family: "Google Sans Flex"
            color: "#E6E1E5"; opacity: 0.8
        }
    }

    // 4 ── Login Card ──
    Rectangle {
        id: card
        width: 400; height: cardContent.height + 64
        anchors.centerIn: parent
        color: "#28242C"; opacity: 0.60; radius: 28
        border.width: 1; border.color: "#33FFFFFF"

        NumberAnimation {
            id: fadeIn; target: card; property: "opacity"
            from: 0; to: 0.60; duration: 400; running: true
        }

        property int shakeOffset: 0
        Behavior on shakeOffset {
            SequentialAnimation {
                loops: 3
                PropertyAnimation { target: card; property: "x"; to: card.x - 6; duration: 50 }
                PropertyAnimation { target: card; property: "x"; to: card.x + 6; duration: 50 }
                PropertyAnimation { target: card; property: "x"; to: card.x; duration: 50 }
            }
        }

        Column {
            id: cardContent
            width: parent.width - 56
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top; anchors.topMargin: 36
            spacing: 18

            // Avatar
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 72; height: 84

                Image {
                    id: avatarImg
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 72; height: 72
                    source: "assets/avatar.png"
                    fillMode: Image.PreserveAspectCrop; visible: false
                    onStatusChanged: {
                        if (status == Image.Error)
                            source = ""
                    }
                }
                Rectangle {
                    id: avatarMask
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 72; height: 72; radius: 36; visible: false
                }
                OpacityMask {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 72; height: 72
                    source: avatarImg; maskSource: avatarMask
                }
            }

            // Username
            Rectangle {
                width: parent.width; height: 52; radius: 12
                color: "#14FFFFFF"; border.width: 1
                border.color: username.activeFocus ? "#D0BCFF" : "#3FFFFFFF"

                Row {
                    anchors.fill: parent; anchors.margins: 12; anchors.leftMargin: 16
                    spacing: 10

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 18; height: 18
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 8; height: 8; radius: 4
                            color: username.activeFocus ? "#D0BCFF" : "#938F99"
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            width: 18; height: 8; radius: 4
                            color: username.activeFocus ? "#D0BCFF" : "#938F99"
                        }
                    }

                    Item {
                        width: parent.width - 48; height: parent.height
                        TextBox {
                            id: username; anchors.fill: parent
                            text: userModel.lastUser
                            font.pixelSize: 16; font.family: "Google Sans Flex"
                            color: "transparent"; borderColor: "transparent"
                            focusColor: "transparent"; hoverColor: "transparent"
                            textColor: "#E6E1E5"
                            KeyNavigation.tab: password
                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    password.focus = true; event.accepted = true
                                }
                            }
                        }
                        Text {
                            text: (username.text || username.activeFocus) ? "" : "用户名"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left; anchors.leftMargin: 4
                            font.pixelSize: 16; font.family: "Google Sans Flex"; color: "#666370"
                        }
                    }
                }
            }

            // Password
            Rectangle {
                width: parent.width; height: 52; radius: 12
                color: "#14FFFFFF"; border.width: 1
                border.color: password.activeFocus ? "#D0BCFF" : "#3FFFFFFF"

                Row {
                    anchors.fill: parent; anchors.margins: 12; anchors.leftMargin: 16
                    spacing: 10

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 14; height: 18
                        Rectangle {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 14; height: 12; radius: 2
                            color: password.activeFocus ? "#D0BCFF" : "#938F99"
                        }
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 1; width: 10; height: 7; radius: 5
                            color: "transparent"; border.width: 2
                            border.color: password.activeFocus ? "#D0BCFF" : "#938F99"
                        }
                    }

                    Item {
                        width: parent.width - 44; height: parent.height
                        PasswordBox {
                            id: password; anchors.fill: parent
                            font.pixelSize: 16; font.family: "Google Sans Flex"
                            color: "transparent"; borderColor: "transparent"
                            focusColor: "transparent"; hoverColor: "transparent"
                            textColor: "#E6E1E5"
                            KeyNavigation.backtab: username
                            Keys.onPressed: {
                                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                    sddm.login(username.text, password.text, sessionIndex)
                                    event.accepted = true
                                }
                            }
                        }
                        Text {
                            text: (password.text || password.activeFocus) ? "" : "密码"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left; anchors.leftMargin: 4
                            font.pixelSize: 16; font.family: "Google Sans Flex"; color: "#666370"
                        }
                    }
                }
            }

            // Error
            Text {
                id: errorText; anchors.horizontalCenter: parent.horizontalCenter
                text: errorMessage
                font.pixelSize: 13; font.family: "Google Sans Flex"; color: "#F2B8B5"
                opacity: errorMessage ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            // Login button
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width; height: 48; radius: 24
                color: loginMouse.pressed ? "#B3D0BCFF" : "#D0BCFF"

                Row {
                    anchors.centerIn: parent; spacing: 10
                    Text {
                        text: "登 录"; font.pixelSize: 16
                        font.family: "Google Sans Flex"; font.bold: true; color: "#381E72"
                    }
                    Text {
                        text: "→"; font.pixelSize: 16
                        font.family: "Google Sans Flex"; font.bold: true; color: "#381E72"
                    }
                }

                MouseArea {
                    id: loginMouse
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.login(username.text, password.text, sessionIndex)
                }
            }
        }
    }

    // 5 ── Bottom bar — circular icon buttons ──
    Row {
        anchors.bottom: parent.bottom; anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter; spacing: 40

        Item {
            width: 44; height: 60
            Rectangle {
                id: shutdownBtn
                anchors.horizontalCenter: parent.horizontalCenter
                width: 44; height: 44; radius: 22
                color: shutdownMouse.pressed ? "#1FFFFFFF" : "#0DFFFFFF"
                Text {
                    anchors.centerIn: parent; text: "⏻"
                    font.pixelSize: 20; color: "#E6E1E5"
                }
                MouseArea {
                    id: shutdownMouse
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.powerOff()
                }
            }
            Text {
                anchors.top: shutdownBtn.bottom; anchors.topMargin: 4
                anchors.horizontalCenter: shutdownBtn.horizontalCenter
                text: "关机"; font.pixelSize: 11
                font.family: "Google Sans Flex"; color: "#938F99"
            }
        }

        Item {
            width: 44; height: 60
            Rectangle {
                id: rebootBtn
                anchors.horizontalCenter: parent.horizontalCenter
                width: 44; height: 44; radius: 22
                color: rebootMouse.pressed ? "#1FFFFFFF" : "#0DFFFFFF"
                Text {
                    anchors.centerIn: parent; text: "↻"
                    font.pixelSize: 20; color: "#E6E1E5"
                }
                MouseArea {
                    id: rebootMouse
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.reboot()
                }
            }
            Text {
                anchors.top: rebootBtn.bottom; anchors.topMargin: 4
                anchors.horizontalCenter: rebootBtn.horizontalCenter
                text: "重启"; font.pixelSize: 11
                font.family: "Google Sans Flex"; color: "#938F99"
            }
        }
    }

    // 6 ── Connections ──
    Connections {
        target: sddm
        function onLoginSucceeded() { flashOverlay.opacity = 1 }
        function onLoginFailed() {
            errorMessage = t.loginFailed; password.text = ""
            card.shakeOffset = 1; errorTimer.start()
        }
        function onInformationMessage(message) {
            if (message) { errorMessage = message; errorTimer.start() }
        }
    }

    Rectangle {
        id: flashOverlay; anchors.fill: parent; color: "#121212"
        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 600 } }
    }

    Timer { id: errorTimer; interval: 5000; onTriggered: errorMessage = "" }

    Component.onCompleted: {
        if (username.text === "") username.focus = true
        else password.focus = true
    }
}
