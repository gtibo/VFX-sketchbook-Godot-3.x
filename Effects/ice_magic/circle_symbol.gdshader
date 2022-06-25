shader_type spatial;
render_mode cull_disabled;
uniform sampler2D circle_sample;
uniform sampler2D circle_small_sample;
uniform sampler2D big_noise_sample;
uniform sampler2D small_noise_sample;

uniform vec4 circle_color : hint_color = vec4(1.0);
uniform vec4 circle_color_2 : hint_color = vec4(1.0);
uniform float brightness : hint_range(0, 10) = 0.5;
uniform float deformation_amount : hint_range(0.0, 1.0) = 0.05;
uniform float erase_amount : hint_range(0.0, 1.0) = 0.0;

vec2 rotateUV(vec2 uv, float rotation)
{
    float mid = 0.5;
    return vec2(
        cos(rotation) * (uv.x - mid) + sin(rotation) * (uv.y - mid) + mid,
        cos(rotation) * (uv.y - mid) - sin(rotation) * (uv.x - mid) + mid
    );
}


void fragment(){
	float big_noise_texture = texture(big_noise_sample, UV + TIME * 0.02).x;
	float small_noise_texture = texture(small_noise_sample, UV - TIME * 0.04).x;
	float noise_texture = smoothstep(0.0, 1.0, big_noise_texture) * smoothstep(0.0, 1.0, small_noise_texture);
	
	vec2 UV_deform = UV + big_noise_texture * deformation_amount - (deformation_amount/2.0);
	
	float circle = texture(circle_sample, rotateUV(UV_deform, TIME * 0.05)).x;
	float circle_2 = texture(circle_small_sample, rotateUV(UV_deform, -TIME * 0.02)).x;
	
	
	
	EMISSION = mix(circle_color.rgb, circle_color_2.rgb, noise_texture) * brightness;
	
	float circle_1_alpha = 1.0 - smoothstep(0.2, 0.8, circle + noise_texture);
	float circle_2_alpha = (1.0 - smoothstep(0.0, 0.8, circle_2 + noise_texture)) * 0.1;
	
	float erasing_start = max(erase_amount, 0.0);
	float erasing_end = min(erase_amount + 0.05, 1.0);
	
	float erasing = smoothstep(erasing_start, erasing_end, noise_texture);
	
	ALPHA = (circle_1_alpha + circle_2_alpha) * erasing;
}