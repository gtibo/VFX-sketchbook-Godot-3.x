tool
extends Spatial

func _process(_delta):
	var t = Time.get_ticks_msec() / 1000.0
	var half_t = (t * 0.5)
	translation.y = sin(t) * 0.1
	rotation.z = sin(half_t) * 0.1
	rotation.x = cos(half_t) * 0.1
	
