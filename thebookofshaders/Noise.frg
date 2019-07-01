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
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);
    //float rnd = random(st);
    //color = vec3(rnd);

    st*=vec2(10.0,3.0);

    float pattern = st.x;

    //vec2 ipos = floor(st);
    //vec2 fpos = fract(st);

    //vec2 tile = truchetPattern(fpos,random(ipos));

    //float f = smoothstep(tile.x-0.3,tile.x,tile.y)-smoothstep(tile.x,tile.x+0.3,tile.y);

    //float f = noise(st);
    float f = GradientNoise(st);

    st = rotate2D(st,GradientNoise(st));

    pattern = lines(st,0.5);




    gl_FragColor = vec4(vec3(pattern),1.0);
}
