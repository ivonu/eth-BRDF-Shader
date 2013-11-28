// Cook Torrance Fragment Shader
precision mediump float;

uniform vec3 materialAmbientColor;
uniform vec3 materialDiffuseColor;
uniform vec3 materialSpecularColor;
uniform float materialShininess;

uniform vec3 lightPosition[3];
uniform vec3 lightColor[3];
uniform vec3 globalAmbientLightColor;

varying vec2 textureCoordinate;
varying vec3 normal;
varying vec4 position;

void main() {
    // ambient
    vec3 color = globalAmbientLightColor * materialAmbientColor;

    vec3 point = position.xyz;
    vec3 normalDirection = normalize(normal);

    vec3 viewDirection = normalize(-point); // vector from point to camera

    float PI = 3.1415926535897932384626433832795;
    float s = 0.7;
    float d = 0.3;
    float dwi = 1.0; // solid angle of a beam of incident light
    float m = 0.3; // root mean square slope of facets
    float n = 1.5; // refraction index

    for (int i = 0; i < 3; i++) {


        vec3 lightDirection = normalize(lightPosition[i] - point); // vector from point to light
        vec3 halfwayDirection = normalize(lightDirection + viewDirection); // halfway vector between lightDirection and viewDirection

        float normalDlight   = max(0.0, dot(normalDirection, lightDirection));
        float normalDview    = max(0.0, dot(normalDirection, viewDirection));
        float normalDhalfway = max(0.0, dot(normalDirection, halfwayDirection));
        float viewDhalfway   = max(0.0, dot(viewDirection, halfwayDirection));

        float a = acos(normalDhalfway); // angle between normal and halfway

        float G = min(1.0, min(
                     (2.0 * normalDhalfway * normalDlight) / (viewDhalfway),
                     (2.0 * normalDhalfway * normalDview) / (viewDhalfway)));

        float D = (1.0 / (m*m*pow(cos(a), 4.0))) * exp(-pow(tan(a) / m, 2.0));
        //float D = 1.0*exp(-(a*a)/(m*m));

        float F0 = pow ((1.0 - n) / (1.0 + n), 2.0);
        float F = F0 + (1.0 - F0) * pow(1.0 - viewDhalfway, 5.0);

        vec3 Rs = materialSpecularColor * lightColor[i] * (F / PI) * ((D*G) / (normalDlight*normalDview));
        vec3 Rd = materialDiffuseColor * lightColor[i] * max(0.0, normalDlight);

        color += dwi * normalDlight * (s*Rs + d*Rd);

    }

    // return color
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}