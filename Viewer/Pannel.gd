extends ColorRect
onready var min_width = $HBoxContainer/Anchor.rect_min_size.x
func _ready():
	$HBoxContainer/Anchor.rect_min_size.x
	get_tree().connect("screen_resized", self, "on_resize")
	
func on_resize():
	rect_position.x = -rect_size.x + min_width

func _on_Pannel_mouse_entered():
	toggle(0)

func _on_Pannel_mouse_exited():
	toggle(-rect_size.x + min_width)
	
func toggle(target_position):
	$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(target_position,0), .2)
	$Tween.start()
