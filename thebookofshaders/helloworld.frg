#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform float iTime;
//uniform vec2  iMouse;
uniform vec2  iResolution;
varying vec2  qt_TexCoord0;

void main(void){
    vec2 uv = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    gl_FragColor = vec4(uv.x,uv.y,0.0,1.0);
}
