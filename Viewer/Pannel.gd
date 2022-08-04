extends ColorRect
onready var min_width = $HBoxContainer/Anchor.rect_min_size.x

var is_closed = false

func _ready():
	$HBoxContainer/Anchor.rect_min_size.x
	get_tree().connect("screen_resized", self, "on_resize")
	
func toggle(target_position):
	$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(target_position,0), .2)
	$Tween.start()
	
func slide_out():
	toggle(-rect_size.x + min_width)
	
func slide_in():
	toggle(0)

func _on_Anchor_toggle():
	is_closed = !is_closed
	if is_closed:
		slide_out()
	else:
		slide_in()
