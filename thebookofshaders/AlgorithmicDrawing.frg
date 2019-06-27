#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform vec2 iTime;
uniform vec2 iMouse;
varying vec2 qt_TexCoord0;

float plot(vec2 st,float pct){
    return smoothstep(pct-0.02,pct,st.y) -
        smoothstep(pct,pct+0.02,st.y);
}

float circle(vec2 st,float radius){
    vec2 mouse = iMouse/iResolution;
    mouse.y = 1.0 - mouse.y;

    float dist = length(mouse - st);
    return 1.0 - smoothstep(radius-0.02,radius+0.02,dist*2.0);

    //vec2 dist = mouse - st;
    //return 1.0 - smoothstep(radius-0.02,radius+0.02,dot(dist,dist)*4.0);
}

void main(void){
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);

    //function
    //float y =st.x;
    //float y = step(0.3,st.x);
    float y = smoothstep(0.2,0.5,st.x) - smoothstep(0.5,0.8,st.x);

    //background color
    vec3 bcolor = vec3(y);

    //Plot a circle
    //float pos = circle(st,0.3);
    //vec3 rcolor = (1.0-pos)*bcolor + pos*vec3(1.0,0.0,1.0);

    //Plot a line;
    float pct = plot(st,y);
    vec3 fcolor = (1.0-pct)*bcolor+pct*vec3(0.0,1.0,0.0);

    gl_FragColor = vec4(fcolor,1.0);
}
