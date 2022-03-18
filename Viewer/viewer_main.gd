extends Node

export(NodePath) onready var vignette_holder = get_node_or_null(vignette_holder)
export(PackedScene) var vignette_scene

var current_selected = null
func _ready():
	var p_source = "res://Viewer/vignettes_data/"
	var vignettes_data = dir_contents(p_source)
	for v_data in vignettes_data:
		var data = load(p_source+v_data)
		var new_vignette : TextureButton = vignette_scene.instance()
		new_vignette.setup(data.title, data.icon)
		vignette_holder.add_child(new_vignette)
		new_vignette.connect("pressed", self, "select_scene", [new_vignette, data.main_scene])
	$CanvasLayer/AnimationPlayer.play("FadeIn")
func select_scene(vignette, main_scene):
	$CanvasLayer/AnimationPlayer.play_backwards("FadeIn")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")
	for child in $Holder.get_children():
		$Holder.remove_child(child)
	$Holder.add_child(main_scene.instance())
	vignette.set_state(true)
	if current_selected && current_selected != vignette:
		current_selected.set_state(false)
	current_selected = vignette
	yield(get_tree(), "idle_frame")
	$CanvasLayer/AnimationPlayer.play("FadeIn")
	
func dir_contents(path):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
