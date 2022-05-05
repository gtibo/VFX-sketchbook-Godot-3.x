extends Spatial

func _ready():
	$AnimationPlayer.play("Start")
	$Particles.emitting = true
func _on_Open_pressed():
	$AnimationPlayer.play("Start")
	$Particles.emitting = true
	

func _on_Close_pressed():
	$AnimationPlayer.play_backwards("Start")
	$Particles.emitting = false


func _on_Error_pressed():
	$AnimationPlayer.play("Error")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("Start")
	
