import QtQuick 2.11

Item {
    ShaderEffect{
        id:effect
        anchors.fill: parent
        property real iTime: 0

        Timer{
            running: true
            triggeredOnStart: true
            repeat: true
            interval: 33
            onTriggered: {
                effect.iTime += 0.1
            }
        }

        fragmentShader:"
#version 330
#define TAU 6.28318530718
#define TILING_FACTOR 1.0
#define MAX_ITER 4

uniform lowp float iTime;
varying mediump vec2 qt_TexCoord0;
uniform lowp float width;
uniform lowp float height;
float waterHighlight(vec2 p, float time, float foaminess)
{
    vec2 i = vec2(p);
    float c = 0.0;
    float foaminess_factor = mix(1.0, 6.0, foaminess);
    float inten = .005 * foaminess_factor;
    for (int n = 0; n < MAX_ITER; n++){
        float t = time * (1.0 - (3.5 / float(n+1)));
        i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
        c += 1.0/length(vec2(p.x / (sin(i.x+t)),p.y / (cos(i.y+t))));
    }
    c = 0.2 + c / (inten * float(MAX_ITER));
    c = 1.17-pow(c, 1.4);
    c = pow(abs(c), 8.0);
    return c / sqrt(foaminess_factor);
}
void main()
{
    float time = iTime * 0.1+23.0;
    vec2 uv = qt_TexCoord0.xy;
    vec2 uv_square = vec2(uv.x * width / height, uv.y);
    float dist_center = pow(2.0*length(uv - 0.5), 2.0);
    float foaminess = smoothstep(0.4, 1.8, dist_center);
    float clearness = 0.1 + 0.9*smoothstep(0.1, 0.5, dist_center);
    vec2 p = mod(uv_square * TAU * TILING_FACTOR, TAU) - 250.0;
    float c = waterHighlight(p, time, foaminess);
    vec3 water_color = vec3(0.0, 0.35, 0.5);
    vec3 color = vec3(c);
    color = clamp(color + water_color, 0.0, 1.0);
    color = mix(water_color, color, clearness);
    gl_FragColor = vec4(color, 1.0);
}"
    }
}
