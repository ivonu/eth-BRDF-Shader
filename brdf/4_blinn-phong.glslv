// Blinn Phong Vertex Shader
attribute vec3 vertexPosition;
attribute vec3 vertexNormal;
attribute vec2 textureCoord;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

varying vec3 vN;
varying vec4 vP;

void main(void) {
    vP = modelViewMatrix * vec4(vertexPosition, 1.);
	vN = normalMatrix * vertexNormal;

	gl_Position = projectionMatrix * vP;
}