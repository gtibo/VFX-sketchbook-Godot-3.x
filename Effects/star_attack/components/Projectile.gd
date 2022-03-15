extends Spatial

var velocity = Vector3(0,4,0)
var gravity = -20

func _process(delta):
	velocity.y += gravity * delta
	translation += velocity * delta
	#if(translation.y < 0):
	#	queue_free()
