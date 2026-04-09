#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:sample_lightmap.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
	//detect player xp level
    vec2 ScrSize = 2.0 / vec2(ProjMat[0][0], -ProjMat[1][1]);
    ivec4 iCol = ivec4(Color * 255. + 0.5);
    bool isXp = Position.z == 0.0
        && Position.y >= ScrSize.y - 36.0
        && Position.y <= ScrSize.y - 25.0
        && abs(Position.x - ScrSize.x / 2.0) <= 33.0
        && (iCol == ivec4(128, 255, 32, 255) || iCol == ivec4(0, 0, 0, 255));

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
	//change player xp level color
	if (isXp && (iCol != ivec4(0, 0, 0, 255))) {
		vertexColor = vec4(0.49605540, 0.98823532, 0.1240138523, 1);
	} else {
		vertexColor = Color * sample_lightmap(Sampler2, UV2);
	}
    //vertexColor = Color * sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
}
