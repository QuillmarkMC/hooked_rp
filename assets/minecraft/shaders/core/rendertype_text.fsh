#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    if (color.r == 0.49605540 && color.g == 0.98823532 && color.b == 0.1240138523) {
        fragColor = vec4(1, 0.843, 0, 1.0);
        return;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}