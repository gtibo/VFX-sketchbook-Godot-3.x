extends OmniLight

var target_color = Color.white
var target_energy = 0.0

func _on_FireWorks_emit_light(color):
	target_color = color
	target_energy += 10.0

func _physics_process(delta):
	target_energy = lerp(target_energy, 0.0, 2 * delta)
	light_energy = target_energy
	
	var color_diff = (target_color - light_color)
	light_color += color_diff * 0.01;

