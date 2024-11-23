shader_type spatial;

//render_mode unshaded;
render_mode unshaded;

uniform sampler2D albedo_tex : source_color;
uniform sampler2D secretPattern : source_color;
uniform sampler2D randomPattern : source_color;
uniform sampler2D colorGradient : repeat_disable, source_color;
uniform float burnRatio : hint_range(0.0, 1.222);
uniform vec4 albedo : source_color = vec4(1.0);

void fragment() {
	// Called for every pixel the material is visible on.
	float lim = burnRatio;
	//float grad = max(texture(randomPattern, UV).r - lim, 0.0);
	//float grad = (texture(randomPattern, UV).r > lim) ? 0.95 : 0.05;
	float randomPixel = texture(randomPattern, UV).r;
	float secretPixel = 1.0 - texture(secretPattern, UV).r;
	float burnlevel = 0.2 * randomPixel +  0.8 * secretPixel;
	if (secretPixel > 0.95) burnlevel = secretPixel;
	//float burnlevel = texture(randomPattern, UV).r;
	float grad = smoothstep(lim, lim-0.3, burnlevel);
	vec4 grad_col = texture(colorGradient, vec2(grad));
	vec4 texture_col = texture(albedo_tex, UV);
	ALBEDO = grad_col.rgb * albedo.rgb * texture_col.rgb;
	//ALBEDO = texture_col.rgb;
	ALPHA = grad_col.a;
	SPECULAR = 0.0;
	ROUGHNESS = 1.0;
}
