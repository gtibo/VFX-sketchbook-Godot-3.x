shader_type spatial;
render_mode cull_disabled;

uniform vec4 color : hint_color = vec4(1.0);
uniform float brightness : hint_range(0, 10) = 0.5;

float fresnel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void fragment(){
	float screen_text_r = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.005, 0.006) * UV.y).r;
	float screen_text_g = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.002, 0.008) * UV.y).g;
	float screen_text_b = texture(SCREEN_TEXTURE, SCREEN_UV).b;
	
	vec3 screen_aberration = vec4(screen_text_r, screen_text_g, screen_text_b, 1.0).rgb;
	vec3 final_color = mix(screen_aberration, color.rgb,  0.1);
	ALBEDO = final_color;
	EMISSION = final_color * 2.0;
	ALPHA = UV.y * (1.0 -fresnel(0.025, NORMAL, VIEW));
}