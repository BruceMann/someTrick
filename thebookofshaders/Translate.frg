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

float box(vec2 st,vec2 size){
    //这一步变换可以理解为将size 转换为坐标对应 比如宽度设为0.6 那么宽度对应的坐标范围为0.3~0.9
    size = vec2(0.5)-size*0.5;

    vec2 uv = smoothstep(size,size+0.01,st);
    uv*=smoothstep(size,size+0.01,1.0-st);
    return uv.x*uv.y;
}

float cross(vec2 st,vec2 size){
    //绘制起点修正为中心点
    return box(st,vec2(size.x,size.y/4.0))+
                box(st,vec2(size.x/4.0,size.y));
}

void main(void){
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    vec2 translate = vec2(cos(iTime),sin(iTime));
    st+=translate*0.25;

    //color = vec3(box(st,vec2(0.2,0.3)));

    color = vec3(cross(st,vec2(0.25)));

    color += vec3(st.x,st.y,0.0);

    gl_FragColor = vec4(color,1.0);

}
