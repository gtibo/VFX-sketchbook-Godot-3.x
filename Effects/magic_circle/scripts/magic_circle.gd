extends Spatial
export(PackedScene) var to_invoke

var open = true

func _ready():
	$AnimationPlayer.play("Appear")

func _on_Open_pressed():
	if open: return
	$AnimationPlayer.play("Appear")
	open = true
func _on_Close_pressed():
	if !open: return	
	$AnimationPlayer.play_backwards("Appear")
	open = false
func _on_Invoke_pressed():
	if !open : return
	$AnimationPlayer.play("Invoke")
	var b = to_invoke.instance()
	b.translation = $Target.translation
	add_child(b)
