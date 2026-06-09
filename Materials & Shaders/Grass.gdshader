shader_type spatial;
render_mode cull_disabled, depth_draw_opaque, specular_toon;

uniform vec4 colour_top : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform vec4 colour_bottom : source_color = vec4(0.0, 0.0, 0.0, 0.0);
uniform float bend = 0.2;

uniform vec3 colour_variation : source_color = vec3(0.0,0.0,0.0);
uniform float patch_scale = 5.0;
uniform sampler2D wind_noise;
varying float v_patch;

uniform vec2 wind_direction = vec2(0.0, 1.0);
uniform float wind_texture_scale = 20.0;
uniform float wind_speed = 0.1;
uniform float still_sway_speed = 4.5;
uniform float still_sway_strength = 0.1;
uniform float gust_strength = 1.0;
uniform float gust_frequency = 0.08;

varying float v_wind_intensity;

void vertex() 
{
	vec3 world_pos = (MODEL_MATRIX * vec4(0.0,0.0,0.0,1.0)).xyz;
	float patch_factor = texture(wind_noise,world_pos.xz / patch_scale).r;
	v_patch = patch_factor;
	
	vec2 global_uv = world_pos.xz / wind_texture_scale;
	vec2 move_uv = global_uv + (normalize(wind_direction) * TIME * wind_speed);
	float noise_val = texture(wind_noise, move_uv).r;

	float gust_mask = smoothstep(gust_frequency, 1.0, noise_val);

	float idle_sway = sin(TIME * still_sway_speed + world_pos.x + world_pos.z) * still_sway_strength;
	float flutter = sin(TIME * 20.0 + world_pos.x) * 0.01;
	float gust_push = (gust_mask * gust_strength) + (gust_mask * flutter);

    v_wind_intensity = gust_mask;
	
	float height = 1.0 - UV.y;
	float bend_strength = pow(height, 1.0);
	vec3 total_offset = vec3(1.0, 0.0, 0.0) * (idle_sway + gust_push) * bend_strength;
	float dist_moved = length(total_offset.xz);
	float y_drop = dist_moved * 0.2 * bend_strength;
	VERTEX += (vec3(0.0,0.0,1.0) * bend * bend_strength) + total_offset;
	VERTEX.y -= y_drop;
}

void fragment() 
{
	vec3 gradient = mix(colour_top.rgb, colour_bottom.rgb, UV.y);
	vec3 varied_colour = mix(gradient,colour_variation,v_patch * 0.3);
	ALBEDO = varied_colour;
	NORMAL_MAP = vec3(0, 1, 0);
}
