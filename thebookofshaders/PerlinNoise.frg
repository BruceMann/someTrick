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

vec4 permute_v4(vec4 x){return mod(((x*34.0)+1.0)*x, 289.0);}
vec2 fade(vec2 t) {return t*t*t*(t*(t*6.0-15.0)+10.0);}

float cnoise(vec2 P){
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, 289.0); // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;
  vec4 i = permute_v4(permute_v4(ix) + iy);
  vec4 gx = 2.0 * fract(i * 0.0243902439) - 1.0; // 1/41 = 0.024...
  vec4 gy = abs(gx) - 0.5;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;
  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);
  vec4 norm = 1.79284291400159 - 0.85373472095314 *
    vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
  g00 *= norm.x;
  g01 *= norm.y;
  g10 *= norm.z;
  g11 *= norm.w;
  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));
  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

//wood texture
float lines(in vec2 pos,float b){
    float scale = 10.0;
    pos*=scale;
    return smoothstep(0.0,
                    .5+b*.5,
                    abs((sin(pos.x*3.1415)+b*2.0))*.5);
}

#define OCTAVES 5
float fbm(in vec2 st){
    //Initial values
    float value =0.0;
    float amplitude = .5;
    float frequency = 0.;

    vec2 shift = vec2(100.0);

    //Rotate to reduce axial bias
    mat2 rot = mat2(cos(0.5),sin(0.5),
                   -sin(0.5),cos(0.5));

    //Loop of octaves
    for(int i=0;i<OCTAVES;i++){
        value += amplitude*(cnoise(st));
        //st*=2.0;
        st = rot*st*2.0+shift;
        amplitude *= .5;
    }
    return value;
}

float fbm_c(in vec2 st){
//Initial values
float value =0.0;
float amplitude = .5;
float frequency = 0.;

//Loop of octaves
for(int i=0;i<OCTAVES;i++){
    value += amplitude*(cnoise(st));
    st*=2.0;
    amplitude *= .5;
}
return value;
}

float pattern_1(in vec2 st){
    return fbm_c(st);
}

float pattern_2(in vec2 p){
vec2 q = vec2( fbm_c( p + vec2(0.0) ),
                fbm_c( p + vec2(1.0) ) );

 return fbm_c( p + q );
}

vec2 r = vec2(0.);
vec2 q = vec2(0.);
float pattern_3(in vec2 p){
     q = vec2(fbm_c(p+vec2(1.0)),fbm_c(p+vec2(1.0)));
     r = vec2(fbm_c(p+q+vec2(iTime)*0.15),fbm_c(p+q+vec2(iTime)*0.6));
    return fbm_c(p+r);
}

void main(){
    //vec4 tex = texture2D(src, qt_TexCoord0);
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);

//q.x = fbm_c( st + 0.01*iTime);
//q.y = fbm_c( st + vec2(1.0));


//r.x = fbm_c( st + 1.0*q + vec2(1.7,9.2)+ 0.15*iTime );
//r.y = fbm_c( st + 1.0*q + vec2(8.3,2.8)+ 0.126*iTime);

float f = pattern_3(st*5)*0.5+0.5;

color = mix(vec3(0.101961,0.619608,0.666667),
            vec3(0.666667,0.666667,0.498039),
            clamp((f),0.0,1.0));

color = mix(color,
            vec3(0,0,0.164706),
            clamp(length(q),0.0,1.0));

color = mix(color,
           vec3(0.666667,1,1),
          clamp(length(r.x),0.0,1.0));

float flow_u = f*f*f+.6*f*f+.5*f;

//color = vec3(f);

gl_FragColor = vec4(color*flow_u,1.);
}
