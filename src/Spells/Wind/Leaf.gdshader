// NOTE: Shader automatically converted from Godot Engine 4.3.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_burley, specular_schlick_ggx;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_nearest_mipmap_anisotropic, repeat_disable;
uniform sampler2D color_ramp : source_color;
uniform float alpha_scissor_threshold : hint_range(0.0, 1.0, 0.001);

void fragment() {
	vec2 base_uv = UV;

	vec4 albedo_tex = texture(texture_albedo, base_uv);

	// Vertex Color Use as Albedo: Enabled
	//albedo_tex *= COLOR;
	vec4 ramp_color = texture(color_ramp, vec2(COLOR.r, 1.0));

	ALBEDO = albedo.rgb * albedo_tex.rgb * ramp_color.rgb;
	//ALBEDO = texture(color_ramp, vec2(COLOR.r, 1.0)).rgb;

	ALPHA *= albedo.a * albedo_tex.a;
	ALPHA_SCISSOR_THRESHOLD = alpha_scissor_threshold;
}
