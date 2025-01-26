shader_type spatial;

render_mode cull_back, unshaded;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
void fragment() {
	ALBEDO = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
