// Blinn Phong Fragment Shader
precision mediump float;

uniform vec3 materialAmbientColor;
uniform vec3 materialDiffuseColor;
uniform vec3 materialSpecularColor;
uniform float materialShininess;

uniform vec3 lightPosition[3];
uniform vec3 lightColor[3];
uniform vec3 globalAmbientLightColor;

varying vec3 normal;
varying vec4 position;

void main() {
    // ambient
    vec3 color = globalAmbientLightColor * materialAmbientColor;


    vec3 point = position.xyz;
    vec3 normalDirection = normalize(normal);
    
    for (int i = 0; i < 3; i++) {

        vec3 lightDirection = normalize(lightPosition[i]-point); // vector from point to light

        // diffuse
        color += materialDiffuseColor * max(0.0, dot(lightDirection, normalDirection)) * lightColor[i];

        // specular highlights
        if (materialShininess > 0.0) {
            vec3 viewDirection = normalize(-point); // vector from point to camera
            vec3 halfwayDirection = normalize(lightDirection + viewDirection); // halfway vector between L and V

            color += materialSpecularColor * pow(max(0.0,dot(normalDirection, halfwayDirection)), materialShininess) * lightColor[i];
        }
    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}