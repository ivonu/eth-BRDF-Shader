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
    float PI = 3.141592;
	float n = 1.5;
	float m = 0.15;
    
	vec3 color = materialAmbientColor * globalAmbientLightColor;

	vec3 point = position.xyz;
	vec3 normalDirection = normalize(normal);
	vec3 viewDirection = normalize(-point);
	
    for (int i = 0; i < 3; i++) {
		vec3 lightDirection = normalize(lightPosition[i]-point);
		vec3 halfwayDirection = normalize(viewDirection + lightDirection);
	
		float dotNL = dot(normalDirection, lightDirection);
		float dotNV = max(0.0, dot(normalDirection, viewDirection));
	
		if (dotNL > 0.0001 && dotNV > 0.0001) {
			float dotNH = max(0.0, dot(normalDirection, halfwayDirection));
			float dotHV = max(0.0, dot(halfwayDirection, viewDirection));
	
			// Schlick 
			float F0 = pow ((n - 1.0) / (n + 1.0), 2.0);
			float F = F0 + (1.0 - F0) * pow(1.0 - dotNL, 5.0);
			
			// Beckmann
			float tanAlpha = sqrt(1.0 - dotNH * dotNH) / dotNH;
			float D = exp(-pow(tanAlpha / m, 2.0)) / (pow(m, 2.0) * pow(dotNH, 4.0));
	 
			float G1 = (2.0 * dotNH * dotNV) / dotHV;
			float G2 = (2.0 * dotNH * dotNL) / dotHV;
			float G = min(1.0, min(G1, G2));
				
			float Rs = (F*D*G) / (3.14159 * dotNL * dotNV)*1.5;
			color += (Rs*lightColor[i]*materialSpecularColor + lightColor[i]*materialDiffuseColor) * dotNL;
		}
    }
    
	gl_FragColor = clamp (vec4(color, 1.0), 0.0, 1.0);
}