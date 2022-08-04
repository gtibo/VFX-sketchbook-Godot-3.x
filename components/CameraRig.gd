extends Spatial

export(NodePath) onready var target = get_node_or_null(target)
export var max_distance : float = 4
export var min_distance : float = 1
onready var current_distance = max_distance

var dragging = false
var current_pos = Vector2.ZERO

func _ready():
	$Camera.translation.z = current_distance
	$Camera.look_at(target.translation,Vector3.UP)
	current_pos.x = -rotation.y
	current_pos.y = -rotation.x
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			#Start Drag :)
			dragging = true
			var zoom_factore = 0
			if event.button_index == BUTTON_WHEEL_UP: zoom_factore = -1
			if event.button_index == BUTTON_WHEEL_DOWN: zoom_factore = 1
			if zoom_factore != 0:
				current_distance += zoom_factore
				current_distance = clamp(current_distance, min_distance, max_distance)
				$Tween.interpolate_property($Camera, "translation", $Camera.translation,Vector3(0,0,current_distance),.1)
				$Tween.start()
				
		else:
			#End Drag :) 
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if !event.relative:return
		var viewport_size = get_viewport().size
		current_pos += event.relative / 400
		current_pos.y = clamp(current_pos.y,-PI*.4,PI*.4)
		set_rotation(Vector3(-current_pos.y,-current_pos.x, 0))
		$Camera.look_at(target.translation,Vector3.UP)


func _on_Tween_tween_step(object, key, elapsed, value):
	$Camera.look_at(target.translation,Vector3.UP)
