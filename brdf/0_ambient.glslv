// Ambient Vertex Shader
attribute vec3 vertexPosition;
attribute vec3 vertexNormal;
attribute vec2 textureCoord;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

void main(void) {
	gl_Position = projectionMatrix * modelViewMatrix * vec4(vertexPosition, 1.);
}