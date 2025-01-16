#version 330 core

out vec4 color;
in vec3 ourColor;
in vec2 texCord;

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform float trans;

void main() {
	color = mix(texture(texture0, texCord), texture(texture1, texCord), trans);
}