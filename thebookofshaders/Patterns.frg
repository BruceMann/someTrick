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

vec2 brickTile(vec2 st,float room){
    st *= room;
    st.x += step(1.0,mod(st.y,2.0))*0.5;
    return fract(st);
}

vec2 movingTile(vec2 st,float room,float speed){
    st*=room;
    float time = iTime*speed;
    if(fract(time)>0.5){
        if(fract(st.y*0.5)>0.5){
            st.x+=fract(time)*2.0;
        }else{
            st.x-=fract(time)*2.0;
        }
    }else{
        if(fract(st.x*0.5)>0.5){
            st.y+=fract(time)*2.0;
        }else{
            st.y-=fract(time)*2.0;
        }
    }
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

vec2 rotateTilePattern(vec2 st){
    st*=2.0;

    // import !!! Give each cell an index number accroding to its position
    float index = 0.0;
    index+=step(1.0,mod(st.x,2.0));
    index+=step(1.0,mod(st.y,2.0))*2.0;

    //      |
    //  2   |   3
    //      |
    //--------------
    //      |
    //  0   |   1
    //      |

    //Make each cell between 0.0-1.0
    st = fract(st);

    //Rotate each cell accroding to the index
    if(index==1.0){
        st = rotate2D(st,PI*0.5);
    }else if(index==2.0){
        st = rotate2D(st,PI*-0.5);
    }else if(index==3.0){
        st = rotate2D(st,PI);
    }
    return st;
}

void main(void){
    vec2 st = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
    vec3 color = vec3(0.0);

    //st = tile(st,4);
    //st = rotate2D(st,PI*0.25);

    //st/=vec2(2.15,0.65);
    //st = brickTile(st,12);
    //st = movingTile(st,10,0.5);

    st = tile(st,3.0);
    st = rotateTilePattern(st);

    //color = 1.0 - vec3(circle(st,0.3));
    //color = vec3(box(st,vec2(0.9),0.01));
    color = vec3(step(st.y,st.x));
    gl_FragColor = vec4(color,1.0);
}
