extends ColorRect
onready var min_width = $HBoxContainer/Anchor.rect_min_size.x
var is_closed = false
func _ready():
	$HBoxContainer/Anchor.rect_min_size.x
	get_tree().connect("screen_resized", self, "on_resize")
	
func on_resize():
	rect_position.x = -rect_size.x + min_width
	is_closed = true
func toggle(target_position):
	$Tween.interpolate_property(self, "rect_position", rect_position, Vector2(target_position,0), .2)
	$Tween.start()
	
func slide_out():
	toggle(-rect_size.x + min_width)
	is_closed = true
	
func slide_in():
	toggle(0)
	is_closed = false
	


func _on_Holder_mouse_entered():
	slide_out()


func _on_Anchor_mouse_entered():
	slide_in()
