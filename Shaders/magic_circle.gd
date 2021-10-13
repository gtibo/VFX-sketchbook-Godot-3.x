extends Spatial

export(PackedScene) var to_invoke


func _on_Open_pressed():
	$AnimationPlayer.play("Appear")


func _on_Invoke_pressed():
	$AnimationPlayer.play("Invoke")
	var b = to_invoke.instance()
	b.translation = $Target.translation
	add_child(b)
