// YUV to RGB matrix
mat3 yuv2rgb = mat3(1.0, 0.0, 1.13983,
                    1.0, -0.39465, -0.58060,
                    1.0, 2.03211, 0.0);

// RGB to YUV matrix
mat3 rgb2yuv = mat3(0.2126, 0.7152, 0.0722,
                    -0.09991, -0.33609, 0.43600,
                    0.615, -0.5586, -0.05639);

mat2 rotate2d(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

mat2 scale(vec2 scale){
    return mat2(scale.x,0,
                0,scale.y);
}

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
