#version 330

uniform highp float iTime;
uniform highp vec2  iMouse;
uniform highp vec2  iResolution;
uniform lowp float  qt_Opacity;
varying mediump vec2 qt_TexCoord0;

float circle(in vec2 _st, in float _radius){
    vec2 mouse = iMouse/iResolution;
    vec2 dist = _st-vec2(mouse);
        return 1.-smoothstep(0.0,
                         _radius+(_radius*0.01),
                         dot(dist,dist)*4.0);
}

void main(void)
{
    float deltaT = abs(sin(3.1415*iTime*0.5));
    vec2 mouse = iMouse/iResolution;
    vec2 st = qt_TexCoord0.xy;

    float d = length(abs(st - mouse));

    vec3 col = vec3(circle(st,0.2));
    //vec3 col = vec3(fract(d*10*(deltaT+2)));

    gl_FragColor = vec4(col,1.0);
}
