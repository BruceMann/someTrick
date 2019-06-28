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

vec2 rotate2D(vec2 st,float angle){
    st-=0.5;
    st = mat2(cos(angle),-sin(angle),
              sin(angle),cos(angle))*st;
    st+=0.5;
    return st;
}

vec2 tile(vec2 st,float zoom){
    st *= zoom;
    return fract(st);
}

float box(vec2 st,vec2 size,float smoothEdges){
    size = vec2(0.5)-size*0.5;
    vec2 aa = vec2(smoothEdges*.5);
    vec2 uv = smoothstep(size,size+aa,st);
    uv*=smoothstep(size,size+aa,vec2(1.0)-st);
    return uv.x*uv.y;
}


float circle(in vec2 _st, in float _radius){
    vec2 l = _st-vec2(0.5);
    return 1.-smoothstep(_radius-(_radius*0.01),
                         _radius+(_radius*0.01),
                         dot(l,l)*4.0);
}

void main(void){
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    st = tile(st,4);
    st = rotate2D(st,PI*0.25);

    color = vec3(box(st,vec2(0.7),0.01));

    gl_FragColor = vec4(color,1.0);
}
