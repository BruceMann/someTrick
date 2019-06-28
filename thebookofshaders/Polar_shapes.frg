#version 330
#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

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

    float N = floor(iTime)+3.0;
    float raduis = 0.5;
    float n = TWO_PI/float(N);

    float f = cos(floor(0.5+a/n)*n-a)*r;

    color = vec3(1.0-smoothstep(raduis,raduis+0.01,f));
    //color = vec3(f);

    //Polar shapes
    //float f = abs(sin(4.0*a));
    //color = vec3(smoothstep(r,r+0.01,f));
    //color = vec3(f);

    gl_FragColor = vec4(color,1.0);
}
