extends Spatial

export(PackedScene) var scene_to_load
export(PackedScene) var trail_scene
export(Material) var second_trail_mat

func _ready():
	for i in 15:
		var t = trail_scene.instance()
		var small_t = trail_scene.instance()
		small_t.trail_length = 6 
		
		var s = scene_to_load.instance()
		t.material_override = t.material_override.duplicate()
		t.material_override.set("shader_param/Offset", i * 10)
		
		s.translation += Vector3(randf(),randf(),randf()) * 10
		$Container.add_child(s)
		t.target_path = s.get_path()
		t.radius = s.size
		add_child(t)
		
		
		small_t.material_override = second_trail_mat
		small_t.target_path = s.get_path()
		small_t.radius = s.size * 2
		add_child(small_t)
