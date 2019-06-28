#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform float iTime;
//uniform vec2 iMouse;
varying vec2 qt_TexCoord0;

void main(){
    vec2 st = vec2(qt_TexCoord0.x,1.0 - qt_TexCoord0.y);
    vec3 color = vec3(0.0);
    //坐标变换  0~1.0 --->  -1.0~1.0
    st = st*2.0-1.0;

    //笛卡尔坐标 to 极坐标
    float r = length(st);
    float a = atan(st.y,st.x);

    float f = abs(sin(4.0*a));
    color = vec3(smoothstep(r,r+0.02,f));
    //color = vec3(f);

    gl_FragColor = vec4(color*vec3(51,167,0)/255.0,1.0);
}
