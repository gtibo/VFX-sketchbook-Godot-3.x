extends Spatial

export(PackedScene) var big_trail
export(PackedScene) var small_trail

var base_power = 20 * rand_range(0.5, 1.2)

func get_random_direction():
	var phi = rand_range(0, PI * 2.0)
	var costheta = rand_range(-1.0, 1.0)
	var theta = acos(costheta)
	var x = sin(theta) * cos(phi)
	var y = sin(theta) * sin(phi)
	var z = cos(theta)
	return Vector3(x,y,z)

func setup(t : Transform, mat, theme : firework_theme):
	$Particles.translation = t.origin
	$Particles.emitting = true
	
	var lighter_mat = mat.duplicate()
	lighter_mat.set_shader_param("first_color", theme.first_color * theme.mult_color)
	lighter_mat.set_shader_param("second_color", theme.mult_color)
	
	for i in range(18):
		var bt = big_trail.instance()
		bt.setup(t.origin, get_random_direction(), base_power * rand_range(0.8, 1.2))
		bt.trail_mat = lighter_mat
		bt.set_particles_color(theme.first_color)
		get_parent().add_child(bt)
		
	for i in range(60):
		var sm = small_trail.instance()
		sm.setup(t.origin, get_random_direction(), (base_power * 0.8) * rand_range(0.1, 1.2))
		sm.trail_mat = mat
		get_parent().add_child(sm)
	
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()
