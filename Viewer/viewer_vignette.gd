extends TextureButton
var zoom_value = 1
var gray_value = 1
var transition_value = 0
var state = false
func set_state(value):
	state = value
	if state:
		zoom_in()
	else:
		zoom_out()
func _ready():
	material = material.duplicate()
	material.set_shader_param("GrayScale",0)
	
func setup(title, vignette):
	$Label.text = title
	texture_normal = vignette
	
func _on_TextureButton_mouse_entered():
	if state : return
	zoom_in()
	
func _on_TextureButton_mouse_exited():
	if state : return
	
	zoom_out()
	
func zoom_in():
	$Tween.interpolate_method(self, "zoom", transition_value, 1, .2)
	$Tween.start()
func zoom_out():
	$Tween.interpolate_method(self, "zoom", transition_value, 0, .2)
	$Tween.start()
func zoom(value):
	transition_value = value
	zoom_value = range_lerp(value,0,1,1,.8)
	gray_value = range_lerp(value,0,1,0,1)
	material.set_shader_param("Scale",zoom_value)
	material.set_shader_param("GrayScale",gray_value)
	
