// Blinn Phong Fragment Shader
precision mediump float;

uniform vec3 materialAmbientColor;
uniform vec3 materialDiffuseColor;
uniform vec3 materialSpecularColor;
uniform float materialShininess;

uniform vec3 lightPosition[3];
uniform vec3 lightColor[3];
uniform vec3 globalAmbientLightColor;

varying vec3 vN;
varying vec4 vP;

void main() {
    // ambient
    vec3 color = globalAmbientLightColor * materialAmbientColor;


    vec3 pos = vP.xyz;
    vec3 N = normalize(vN);
    for (int i = 0; i < 3; i++) {

        vec3 L = normalize(lightPosition[i]-pos); // vector from point to light

        // diffuse
        color += materialDiffuseColor * max(0.0, dot(L, N)) * lightColor[i];

        // specular highlights
        if (materialShininess > 0.0) {
            vec3 V = normalize(-pos); // vector from point to camera
            vec3 H = normalize(L + V); // halfway vector between L and V

            color += materialSpecularColor * pow(max(0.0,dot(N, H)), materialShininess) * lightColor[i];
        }
    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}