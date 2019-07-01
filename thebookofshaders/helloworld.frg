#version 330
#ifdef GL_ES
precision mediump float;
#endif

uniform float iTime;
//uniform vec2  iMouse;
uniform vec2  iResolution;
varying vec2  qt_TexCoord0;

void main(void){
    vec2 uv = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    float color =  (step(length(uv),0.6) -
                    step(length(uv),0.4)) +
                    (step(length(uv-vec2(1.)),0.6) -
                    step(length(uv-vec2(1.)),0.4));

    color = smoothstep(uv.x-0.01,uv.x,uv.y);
    //color = step(uv.x,uv.y);

    gl_FragColor = vec4(vec3(color),1.0);
}
