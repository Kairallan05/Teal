shader_type spatial;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform float mesh_size = 2.0;
uniform float noise_scale = 1;
const vec2 normal_scroll = vec2(-0.1, 0.0);
varying vec2 tex_position;
uniform vec4 colour : source_color = vec4(0.0, 0.0, 0.0, 0.0);

void vertex() {
	tex_position = (VERTEX.xz / mesh_size + 0.5) * noise_scale;
}

void fragment() {
	vec2 uv1 = (tex_position * 1.0) + TIME * normal_scroll;
	vec2 uv2 = (tex_position * 0.5) + TIME * -normal_scroll.yx;
	vec3 n1 = texture(noise2, uv1).xyz;
	vec3 n2 = texture(noise1, uv2).xyz;
	NORMAL_MAP = mix(n1, n2, 1.2);
	ALBEDO = colour.rgb;
	ALPHA = colour.a;
}
