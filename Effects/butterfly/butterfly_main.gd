extends Spatial

var mdt :MeshDataTool = MeshDataTool.new()
export var butterfly:PackedScene
var butterflies = []
export var emitter_path : NodePath
onready var emitter_mesh = get_node(emitter_path)

var is_visible = true

func _ready():
	var vertices = emitter_mesh.mesh.get_faces()
	mdt.create_from_surface(emitter_mesh.mesh,0)
	var faces = []
	for face_id in range(0,vertices.size(),3):
		var p0 = vertices[face_id]
		var p1 = vertices[face_id + 1]
		var p2 = vertices[face_id + 2]
		var face_center = (p0+p1+p2)/3
		var b = butterfly.instance()
		butterflies.append(b)
		b.target_offset = face_center
		b.translation = face_center
		b.target = emitter_mesh
		$Boids.add_child(b)
	$AnimationPlayer.play("Appear")

func _on_Toggle_pressed():
	is_visible = !is_visible
	for butterfly in butterflies:
		butterfly.set_visibility(is_visible)
	if is_visible:
		$AnimationPlayer.play("Appear")
	else:
		$AnimationPlayer.play_backwards("Appear")
		
func _on_Move_pressed():
	$Path_tween.interpolate_property($Path/PathFollow, "unit_offset", 0, 1, 6)
	$Path_tween.start()
