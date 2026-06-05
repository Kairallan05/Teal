shader_type spatial;
render_mode specular_toon;

uniform sampler2D noise;
uniform sampler2D normalmap;
uniform float mesh_size = 2.0;
uniform float noise_scale = 1;
uniform float wave_height = 1;
uniform vec2 normal_scroll = vec2(0.01, 0.05);

varying vec2 tex_position;

void vertex() {
    tex_position = (VERTEX.xz / mesh_size + 0.5) * noise_scale;
    
    vec2 uv1 = tex_position + TIME * vec2(0.1, 0.05);
    vec2 uv2 = tex_position + TIME * vec2(-0.05, 0.08);
    float height = (texture(noise, uv1).x + texture(noise, uv2).x) / 2.0;
    
    VERTEX.y += height * wave_height;
}

void fragment() {
    vec2 uv1 = tex_position + TIME * normal_scroll;
    vec2 uv2 = tex_position + TIME * -normal_scroll.yx;

    vec3 n1 = texture(normalmap, uv1).xyz;
    vec3 n2 = texture(normalmap, uv2).xyz;
    NORMAL_MAP = mix(n1, n2, 0.5);

    float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
    RIM = 0.2;
    METALLIC = 0.2;
    ROUGHNESS = 0.05 * (1.0 - fresnel);
    ALBEDO = vec3(0.03, 0.15, 0.4) + (0.1 * fresnel);
}
