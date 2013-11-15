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


    vec3 pos = vP.xyz;
    vec3 N = normalize(vN);
    for (int i = 0; i < 3; i++) {

        vec3 Lm = normalize(lightPosition[i]-pos); // vector from point to light

        // diffuse
        color += materialDiffuseColor * max(0.0, dot(Lm, N)) * lightColor[i];

        // specular highlights
        if (materialShininess > 0.0) {
            vec3 Rm = normalize(reflect(-Lm, N)); // vector of reflected light
            vec3 V = normalize(-pos); // vector from point to camera
            color += materialSpecularColor * pow(max(0.0,dot(Rm, V)), materialShininess) * lightColor[i];
        }
    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}