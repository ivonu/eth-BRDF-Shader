precision mediump float;

uniform vec3 materialAmbientColor;
uniform vec3 materialDiffuseColor;
uniform vec3 materialSpecularColor;
uniform float materialShininess;

uniform vec3 lightPosition[3];
uniform vec3 lightColor[3];
uniform vec3 globalAmbientLightColor;

varying vec2 vTC;
varying vec3 vN;
varying vec4 vP;

void main() {
    // ambient
    vec3 color = globalAmbientLightColor * materialAmbientColor;


    // diffuse
    vec3 pos = vP.xyz;
    vec3 n = normalize(vN);
    for (int i = 0; i < 3; i++) {

        vec3 point2light = normalize(lightPosition[i]-pos);
        color += materialDiffuseColor * max(0.0, dot(n, point2light)) * lightColor[i];
    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}


