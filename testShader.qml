import QtQuick 2.11

Item {
    ShaderEffect{
        id:effect
        anchors.fill: parent
        property real iTime: 0

        Timer{
            running: true
            triggeredOnStart: true
            repeat: true
            interval:30
            onTriggered: {
                effect.iTime += 0.01
            }
        }

        fragmentShader: "
uniform highp float iTime;

void main(void)
{
    highp float color = sin(3.1415925*iTime);
    gl_FragColor = vec4(color,1.0 - color,0.0,1.0);
}
        "
    }
}
