#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform float iTime;
//uniform vec2 iMouse;
varying vec2 qt_TexCoord0;
uniform sampler2D src;

vec2 st;

float circle(float r){
    float dis = distance(vec2(0.5),st);
    return 1.0-smoothstep(r-0.01,r+0.01,dis);
}

void main(void){
    vec4 tex = texture2D(src, qt_TexCoord0);
    st = vec2(qt_TexCoord0.x,1.0 - qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    //remap the space to -1. to 1.
    st = st*2-1.0;

    //add animation
    float t = abs(sin(iTime));
    //color = vec3(circle(0.5*t));

    //distance field
    //float dis = distance(abs(st),vec2(0.5));

    //use fract
    float dis = distance(abs(st),vec2(0.5));
    dis = length(max(abs(vec2(st.x*1.6,st.y))-0.6,0.0));


    //color = vec3(fract(dis*3.0));
    //color = vec3(dis);

    color = vec3(step(0.3,dis)*(1.0-step(0.4,dis)));
    //color = vec3(dis);
    color = vec3(smoothstep(0.3,0.29,dis))*tex.rgb;

    gl_FragColor = vec4(color,1.0);
}
