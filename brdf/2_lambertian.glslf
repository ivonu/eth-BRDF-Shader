// Lambertian Fragment Shader
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


    // diffuse
    vec3 point = position.xyz;
    vec3 normalDirection = normalize(normal);
    for (int i = 0; i < 3; i++) {

        vec3 lightDirection = normalize(lightPosition[i]-point);
        color += materialDiffuseColor * max(0.0, dot(normalDirection, lightDirection)) * lightColor[i];
    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}


