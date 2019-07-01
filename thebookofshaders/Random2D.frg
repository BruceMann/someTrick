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

float random(vec2 st){
    return fract(sin(dot(st.xy,
                vec2(12.9898,78.233)))*43758.5453123);
}

vec2 truchetPattern(in vec2 st,in float index){
    index = fract((index-0.5)*2.0);
    if(index>0.75){
        st=vec2(1.0)-st;
    }else if(index>0.5){
        st=vec2(1.0-st.x,st.y);
    }else if(index>0.25){
        st=1.0-vec2(1.0-st.x,st.y);
    }
    return st;
}

void main(){
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);
    //float rnd = random(st);
    //color = vec3(rnd);

    st*=10.0;
    vec2 ipos = floor(st);
    vec2 fpos = fract(st);

    vec2 tile = truchetPattern(fpos,random(ipos));

    float f = smoothstep(tile.x-0.3,tile.x,tile.y)-smoothstep(tile.x,tile.x+0.3,tile.y);

    color = vec3(f);

    gl_FragColor = vec4(color,1.0);
}
