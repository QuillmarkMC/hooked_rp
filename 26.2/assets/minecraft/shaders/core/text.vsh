#version 330

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:sample_lightmap.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in ivec2 UV2;
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
#endif

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

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = Color;
#endif
	//change player xp level color
	if (isXp && (iCol != ivec4(0, 0, 0, 255))) {
		vertexColor = vec4(0.49605540, 0.98823532, 0.1240138523, 1);
	}
    texCoord0 = UV0;
}
