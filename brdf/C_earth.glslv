// Cook Torrance Vertex Shader
attribute vec3 vertexPosition;
attribute vec3 vertexNormal;
attribute vec2 textureCoord;

uniform mat4 projectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

varying vec2 textureCoordinate;
varying vec3 normal;
varying vec4 position;

void main(void) {
    position          = modelViewMatrix * vec4(vertexPosition, 1.);
	textureCoordinate = textureCoord;
	normal            = normalMatrix * vertexNormal;

	gl_Position = projectionMatrix * modelViewMatrix * vec4(vertexPosition, 1.);
}