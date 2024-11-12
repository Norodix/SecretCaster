shader_type spatial;

//render_mode unshaded;

uniform sampler2D secretPattern;
uniform sampler2D randomPattern;
uniform sampler2D colorGradient : repeat_disable;
uniform float burnRatio : hint_range(0.0, 1.3);
uniform vec4 albedo : source_color = vec4(0.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float lim = burnRatio;
	//float grad = max(texture(randomPattern, UV).r - lim, 0.0);
	//float grad = (texture(randomPattern, UV).r > lim) ? 0.95 : 0.05;
	float randomPixel = texture(randomPattern, UV).r;
	float secretPixel = texture(secretPattern, UV).r;
	float burnlevel = randomPixel + secretPixel;
	//float burnlevel = texture(randomPattern, UV).r;
	float grad = smoothstep(lim, lim-0.3, burnlevel);
	vec4 col = texture(colorGradient, vec2(grad));
	ALBEDO = col.rgb * albedo.rgb;
	ALPHA = col.a;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
