#version 330

// http://www.pouet.net/prod.php?which=57245
// If you intend to reuse this shader, please add credits to 'Danilo Guanabara'

#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 iResolution;
uniform float iTime;
//uniform vec2 iMouse;
varying vec2 qt_TexCoord0;

void main(void){
	vec3 c;
        vec2 r = iResolution;
        vec2 fragCoord = vec2(qt_TexCoord0.x,1.0-qt_TexCoord0.y);
        float l,z=iTime;
	for(int i=0;i<3;i++) {
                vec2 uv,p=fragCoord.xy;
		uv=p;
		p-=.5;
                p.x*=iResolution.x/iResolution.y;
		z+=.07;
		l=length(p);
		uv+=p/l*(sin(z)+1.)*abs(sin(l*9.-z*2.));
		c[i]=.01/length(abs(mod(uv,1.)-.5));
	}
        gl_FragColor=vec4(c/l,iTime);
}
