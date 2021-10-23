extends Spatial
func _process(delta):
	var time = OS.get_ticks_msec() * .01
	translation = Vector3(sin(time * .2) * 6, sin(time * .1) * 10, cos(-time * .2) * 6)
