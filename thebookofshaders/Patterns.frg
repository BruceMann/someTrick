#version 330
#ifdef GL_ES
precision mediump float;
#endif

//#include <CommonFunc.frg>

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 iResolution;
uniform float iTime;
//uniform vec2 iMouse;
varying vec2 qt_TexCoord0;

float circle(in vec2 _st, in float _radius){
    vec2 l = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*4.0);
}

void main(void){
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    st*=3.0;
    st = fract(st);
    color = vec3(st,0.0);
    color = vec3(circle(st,0.5));

    gl_FragColor = vec4(color,1.0);
}
