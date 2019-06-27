import QtQuick 2.11


ShaderEffect{
    id:effect
//    anchors.fill: parent
    property real iTime: 0
    property point iMouse:Qt.point(0.0,0.0)
    property bool hover: true
    property size iResolution:Qt.size(effect.width,effect.height)
    property string frgShaderFile:"qrc:/shaders/inputparam.frg"
    Timer{
        running: true
        triggeredOnStart: true
        repeat: true
        interval: 33
        onTriggered: {
            effect.iTime += 0.1
        }
    }

    MouseArea{
        anchors.fill: parent
        onMouseXChanged: {
            console.log(mouseX,mouseY)
             parent.iMouse = Qt.point(mouseX,mouseY)
        }

        hoverEnabled: true
    }


    fragmentShader:frgShaderFile

}

