#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform float iTime;
uniform vec2 iMouse;
varying vec2 qt_TexCoord0;

float genline(vec2 st,bool row,vec2 pos,float width){
    return row?1.0-(step(pos.x,st.x)-step(pos.x+width,st.x))
    :1.0-(step(pos.y,st.y)-step(pos.y+width,st.y));
}


void main(){
    vec2 st = vec2(qt_TexCoord0.x,1.0 - qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    //float left   = step(0.1,st.x);
    //float bottom = step(0.1,st.y);

    //color = vec3(left*bottom);
    //gl_FragColor = vec4(color,1.0);

    //bottom-left
    vec2 bl = step(0.025,st);
    float pct = bl.x*bl.y;

    //top-right
    vec2 tr = step(0.025,1.0-st);
    pct *= (tr.x*tr.y);

    color = mix(vec3(0.0,0.0,0.0),vec3(pct),
         genline(st,true,vec2(0.12),0.025)
        *genline(st,true,vec2(0.66),0.025)
        *genline(st,true,vec2(0.87),0.025)
        *genline(st,false,vec2(0.2),0.025)
        *genline(st,false,vec2(0.68),0.025)
        *genline(st,false,vec2(0.91),0.025)
    );

    color *= vec3(246.0,238.0,225.0)/255.0;

    gl_FragColor = vec4(color,1.0);

}
