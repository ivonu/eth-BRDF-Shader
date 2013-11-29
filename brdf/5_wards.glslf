// Wards Fragment Shader
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
varying vec3 tangent;	

void main() {

	vec3 color = materialAmbientColor * globalAmbientLightColor;
	
	vec3 point = position.xyz;
	vec3 normalDirection = normalize(normal);
	vec3 tangentDirection = normalize(tangent); 
	vec3 binormalDirection = normalize(cross(tangentDirection, normalDirection));
	vec3 viewDirection = normalize(-point);

    float alphaX = 0.15;
    float alphaY = 0.75;	
	float PI = 3.14159;
	
    for (int i = 0; i < 1; i++) {
		vec3 lightDirection = normalize(lightPosition[i]-point);
		vec3 halfwayDirection = normalize(viewDirection + lightDirection);

		float dotNL = max(0.0, dot(normalDirection, lightDirection));
		float dotNV = max(0.0, dot(normalDirection, viewDirection));

		if (dotNL > 0.0001 && dotNV > 0.0001) {
			float dotHX = dot(halfwayDirection, tangentDirection);
			float dotHY = dot(halfwayDirection, binormalDirection);
			float dotHN = dot(halfwayDirection, normalDirection);
		
		
			float tmp = -2.0 * (pow((dotHX / alphaX), 2.0) + pow((dotHY / alphaY), 2.0) / (1.0 + dotHN));
			float spec = (1.0 / (4.0 * PI * alphaX * alphaY)) * (sqrt(dotNL / dotNV)) * exp(tmp);
			
			color += clamp (materialDiffuseColor*dotNL + materialSpecularColor*spec*1.5, 0.0, 1.0);
		}
	}

	gl_FragColor = clamp(vec4(color.rgb, 1.0), 0.0, 1.0);
}