// Ambient Fragment Shader
precision mediump float;

uniform vec3 materialAmbientColor;
uniform vec3 materialDiffuseColor;
uniform vec3 materialSpecularColor;
uniform float materialShininess;

uniform vec3 lightPosition[3];
uniform vec3 lightColor[3];
uniform vec3 globalAmbientLightColor;

void main(void) {
	vec3 color = globalAmbientLightColor * materialAmbientColor;
	gl_FragColor = clamp(vec4(color, 1.), 0., 1.);
}