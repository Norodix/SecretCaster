shader_type spatial;

uniform sampler2D albedo : hint_default_black;
uniform sampler2D normalmap : hint_normal;
uniform sampler2D roughness : hint_default_white;

varying float dist;


void vertex() {
	dist = distance(NODE_POSITION_WORLD, CAMERA_POSITION_WORLD);
	VERTEX.y = VERTEX.y - smoothstep(10.0, 15.0, dist) * 10.0;
}

void fragment() {
	vec3 alb = texture(albedo, UV).rgb;
	vec3 nrm = texture(normalmap, UV).rgb;
	float rough = texture(roughness, UV).r;
	
	ALBEDO = alb * 0.2;
	ALPHA = 1.0 - smoothstep(13.0, 15.0, dist);
	NORMAL_MAP = nrm;
	ROUGHNESS = rough;
}
