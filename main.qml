import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2


Window {
    id:window
    property int cellSize: 300

    visible: true
    width: cellSize*4
    height: 900
    title: qsTr("Hello World")

    Item{
        id:root
        anchors.fill: parent
        ShaderEffectSource{
            id:theSource
            sourceItem: img
            //            hideSource: true
        }

        Grid{
            anchors.fill: root
            columns: window.width/window.cellSize

            Image{
                id:img
                source: "qrc:/images/201807011113128645.jpg"
                fillMode:Image.PreserveAspectFit
                width: 300
                height: 300
                Rectangle{
                    anchors.fill: parent
                    color:"#00000000"
                    border.color: "gray"
                    border.width: 1
                }
                Component.onCompleted: {
                    console.log(img.width,img.height)
                    console.log(img.paintedWidth,img.paintedHeight)
                }
            }

            Image {
                id: noiseImg
                source: "qrc:/images/v2-f99f4da5581dcac3b0a5325e35f7fe8a_hd.jpg"
                width: img.paintedWidth
                height: img.paintedHeight
                fillMode:Image.Stretch
                visible: false
            }

            Rectangle{
                id:container
                width: img.width
                height: img.height
                Rectangle{
                    anchors.fill: parent
                    color:"#00000000"
                    border.color: "gray"
                    border.width: 1
                }

                ShaderEffect {
                    id:grayShader
                    width: img.paintedWidth
                    height: img.paintedHeight
                    anchors.centerIn: parent
                    property variant src: img
                    property variant noise: noiseImg
                    property real time:0.1

                    SequentialAnimation on time{
                        id:anim
                        NumberAnimation{duration: 2000;to:1.0}
                        NumberAnimation{duration: 2000;to:0.0}
                        loops:Animation.Infinite
                        //                        running: false
                    }

                    MouseArea{
                        property bool hasClicked: false
                        anchors.fill: parent
                        onClicked: {
                            if(hasClicked){
                                anim.stop()
                            }else{
                                anim.start()
                            }
                            hasClicked = !hasClicked
                        }
                    }


                    vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }"
                    fragmentShader: "
            varying highp vec2 coord;
            uniform sampler2D src;
            uniform sampler2D noise;
            uniform lowp float qt_Opacity;
            uniform lowp float time;

            float circle(vec2 st,float r){
                float dist = length(vec2(0.5)-st);
                return 1.0-smoothstep(r-0.01,r+0.01,dist*2.0);
            }

            void main() {
                lowp vec4 tex = texture2D(src, coord);
                lowp vec4 noiseTex =  texture2D(noise, coord);

                vec3 color;
//                //gray texture
//                gl_FragColor = vec4(vec3(dot(tex.rgb,
//                                    vec3(0.344, 0.5, 0.156))),
//                                         tex.a) * qt_Opacity;
                lowp float alpha = 1.0 - step(time,noiseTex.r);

                color = mix(vec3(1.0),vec3(tex.rgb),circle(coord,0.99));
                gl_FragColor = vec4(color,alpha)*qt_Opacity;
            }"
                }
            }

            HeartBeat{
                width: 300
                height: 300
            }
            InputParam{
                width: 300
                height: 300
                iResolution:Qt.size(width,height)
            }
            InputParam{
                width: 300
                height: 300
                fragmentShader: "qrc:/thebookofshaders/helloworld.frg"
                //                fragmentShader: "qrc:/thebookofshaders/Shapes.frg"
            }
            Rectangle{
                width: 300
                height: 300
                color:"black"
                InputParam{
                    anchors.centerIn: parent
                    width: img.paintedWidth
                    height: img.paintedHeight
                    src:img

                    //                fragmentShader: "qrc:/thebookofshaders/AlgorithmicDrawing.frg"
                    //                fragmentShader: "qrc:/thebookofshaders/Shapes_rect.frg"
                    fragmentShader: "qrc:/thebookofshaders/Shapes_circle.frg"
                }
            }
            InputParam{
                width: 300
                height: 300
                fragmentShader: "qrc:/thebookofshaders/Silexars.frg"
            }
            InputParam{
                width: 300
                height: 300
                fragmentShader:"qrc:/thebookofshaders/Color_Mix.frg"
            }
            InputParam{
                width: 300
                height: 300
                fragmentShader:"qrc:/thebookofshaders/Color_HSB.frg"
            }
            InputParam{
                width: 300
                height: 300
                fragmentShader: "qrc:/thebookofshaders/Polar_shapes.frg"
            }

        }
    }
}
