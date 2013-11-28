// Wards Vertex Shader
attribute vec3 vertexPosition;
attribute vec3 vertexNormal;
attribute vec2 textureCoord;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

varying vec3 normal;
varying vec4 position;
varying vec3 tangent;

void main(void) {
    position = modelViewMatrix * vec4(vertexPosition, 1.);
	normal = normalMatrix * vertexNormal;
	tangent = cross(normal, vec3(1.0,0.0,0.0));

	gl_Position = projectionMatrix * position;
}