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
uniform sampler2D src;

vec3 mod289(vec3 x){return x-floor(x*(1.0/289.0))*289.0;}
vec2 mod289(vec2 x){return x-floor(x*(1.0/289.0))*289.0;}
vec3 permute(vec3 x){return mod289(((x*34.0)+1.0)*x);}

float snoise(vec2 v) {
    const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                        0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                        -0.577350269189626,  // -1.0 + 2.0 * C.x
                        0.024390243902439); // 1.0 / 41.0
    vec2 i  = floor(v + dot(v, C.yy) );
    vec2 x0 = v -   i + dot(i, C.xx);
    vec2 i1;
    i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
    vec4 x12 = x0.xyxy + C.xxzz;
    x12.xy -= i1;
    i = mod289(i); // Avoid truncation effects in permutation
    vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
        + i.x + vec3(0.0, i1.x, 1.0 ));

    vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
    m = m*m ;
    m = m*m ;
    vec3 x = 2.0 * fract(p * C.www) - 1.0;
    vec3 h = abs(x) - 0.5;
    vec3 ox = floor(x + 0.5);
    vec3 a0 = x - ox;
    m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
    vec3 g;
    g.x  = a0.x  * x0.x  + h.x  * x0.y;
    g.yz = a0.yz * x12.xz + h.yz * x12.yw;
    return 130.0 * dot(m, g);
}

//2D Random
float random(vec2 st){
    return fract(sin(dot(st.xy,
                vec2(12.9898,78.233)))*43758.5453123);
}

vec2 random2(vec2 st){
    st = vec2( dot(st,vec2(127.1,311.7)),
              dot(st,vec2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

//2D rotate
vec2 rotate2D(in vec2 st,float angle){
st-=0.5;
st = mat2(cos(angle),-sin(angle),
          sin(angle),cos(angle))*st;
st+=0.5;
return st;

}

//2D Noise
float noise(in vec2 st){
    vec2 i = floor(st);
    vec2 f = fract(st);

    //Four corners in 2D of a tile
    float a = random(i);
    float b = random(i+vec2(1.0,0.0));
    float c = random(i+vec2(0.0,1.0));
    float d = random(i+vec2(1.0,1.0));

    //Smooth Interpolation
    vec2 u = smoothstep(0.0,1.0,f);

    return mix(a,b,u.x)+
            (c-a)*u.y*(1.0-u.x)+
            (d-b)*u.x*u.y;
}

//gradient noise
float GradientNoise(vec2 st){
    vec2 i = floor(st);
    vec2 f = fract(st);

    vec2 u = f*f*(3.0-2.0*f);

 return mix( mix( dot( random2(i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ),
                  dot( random2(i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
             mix( dot( random2(i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ),
                  dot( random2(i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);

}

//wood texture
float lines(in vec2 pos,float b){
    float scale = 10.0;
    pos*=scale;
    return smoothstep(0.0,
                    .5+b*.5,
                    abs((sin(pos.x*3.1415)+b*2.0))*.5);
}

void main(){
    vec4 tex = texture2D(src, qt_TexCoord0);
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    vec2 pos = vec2(st*3.);

    float DF = 0.0;

    // Add a random position
    float a = 0.0;
    vec2 vel = vec2(iTime*.1);
    DF += snoise(pos+vel)*.25+.25;

    // Add a random position
    a = snoise(pos*vec2(cos(iTime*0.15),sin(iTime*0.1))*0.1)*3.1415;
    vel = vec2(cos(a),sin(a));
    DF += snoise(pos+vel)*.25+.25;

    color = vec3( smoothstep(.5,.75,fract(DF)) );
    color *= (vec3(1.0)-vec3(0,134,139)/255.0);
    //color *= tex.rgb;
    gl_FragColor = vec4(1.0-color,1.0);
}
