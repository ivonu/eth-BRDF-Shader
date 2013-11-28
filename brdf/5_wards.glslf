// Wards Fragment Shader
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
varying vec3 vTan;

void main() {
    // ambient
    vec3 color = globalAmbientLightColor * materialAmbientColor;

    vec3 point = vP.xyz;
    vec3 normal = normalize(vN);

    vec3 viewDirection = normalize(-point); // vector from point to camera

    vec3 X = normalize(vTan);
    vec3 Y = normalize(cross(normal,X));

    float aX = 0.088;
    float aY = 0.13;

    float pd = 0.15; // magnitude
    float ps = 0.19; // magnitude

    float PI = 3.1415926535897932384626433832795;

    for (int i = 0; i < 3; i++) {

        vec3 lightDirection = normalize(lightPosition[i] - point); // vector from point to light
        vec3 halfwayDirection = normalize(lightDirection + viewDirection); // halfway vector between lightDirection and viewDirection

        // diffuse
        color += pd * materialDiffuseColor * max(0.0, dot(lightDirection, normal)) * lightColor[i];

        // specular highlights
        if (materialShininess > 0.0 && dot(lightDirection, normal) >= 0.0) {

            float viewDnormal  = max(0.0, dot(viewDirection, normal));
            float lightDnormal = max(0.0, dot(lightDirection, normal));
            float halfDnormal  = max(0.0, dot(halfwayDirection, normal));
            float halfDx       = max(0.0, dot(halfwayDirection, X));
            float haldDy       = max(0.0, dot(halfwayDirection, Y));

            float fr = (ps / (4.0 * PI * aX * aY * sqrt(viewDnormal * lightDnormal))) *
                        exp (-(pow(halfDx / aX, 2.0) + pow(haldDy / aY, 2.0)) / (pow(halfDnormal, 2.0)));

            color += materialSpecularColor * fr;
        }
    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}