extends RigidBody

func _ready():

	$CSGBox2.material = $CSGBox2.material.duplicate()
	angular_velocity = Vector3(rand_range(-1,1),rand_range(-1,1),rand_range(-1,1))
	$AnimationPlayer.play("Invoke")



func _on_Timer_timeout():
	$Tween.interpolate_property(self, "scale", 
	Vector3(1,1,1), 
	Vector3(0,0,0), .2, Tween.TRANS_BACK)
	$Tween.start()

func _on_Tween_tween_all_completed():
	queue_free()
