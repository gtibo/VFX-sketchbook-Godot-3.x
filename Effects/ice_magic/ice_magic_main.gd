extends Spatial

var active = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		toggle()

func _ready():
	toggle()

func toggle():
	active = !active
	if active:
		$AnimationPlayer.play("appear")
	else:
		$AnimationPlayer.play("erase")
