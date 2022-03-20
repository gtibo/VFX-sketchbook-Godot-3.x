extends Spatial

func _ready():
	$Particles.emitting = false
func _on_Invoke_pressed():
	$AnimationPlayer.play("Fade")
