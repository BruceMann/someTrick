#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform float iTime;
uniform vec2 iMouse;
varying vec2 qt_TexCoord0;

vec3 colorA = vec3(0.149,0.141,0.912);
vec3 colorB = vec3(1.000,0.833,0.224);

float plot(vec2 st,float pct){
    return smoothstep(pct-0.01,pct,st.y) -
        smoothstep(pct,pct+0.01,st.y);
}

void main(void){
    vec3 color = vec3(0.0);

    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);

    vec3 pct;
    //pct.r = smoothstep(0.1,0.9,st.x);
    pct.r = 1.0 - st.x;
    pct.g = 0.5*sin(2.0*st.x*3.1415+iTime)+0.5;
    pct.b = st.x;

    //background color
    color = mix(colorA,colorB,pct);

    //line color mix
    color = mix(color,vec3(1.0,0.0,0.0),plot(st,pct.r));
    color = mix(color,vec3(0.0,1.0,0.0),plot(st,pct.g));
    color = mix(color,vec3(0.0,0.0,1.0),plot(st,pct.b));

    gl_FragColor = vec4(color,1.0);
}

