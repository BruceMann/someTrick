#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform float iTime;
//uniform vec2 iMouse;
varying vec2 qt_TexCoord0;

vec2 st;

float circle(float r){
    float dis = distance(vec2(0.5),st);
    return 1.0-smoothstep(r-0.01,r+0.01,dis);
}

void main(void){
     st = vec2(qt_TexCoord0.x,1.0 - qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    //add animation
    float t = abs(sin(iTime));
    color = vec3(circle(0.5*t));

    //distance field
    //float dis = distance(st,vec2(0.1));



    gl_FragColor = vec4(color,1.0);



}
