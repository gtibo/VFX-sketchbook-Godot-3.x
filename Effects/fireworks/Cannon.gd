extends Spatial

onready var timer = $Timer

signal shoot(transform)

func _ready():
	timer.connect("timeout", self, "on_timeout")
	
func on_timeout():
	timer.wait_time = rand_range(0.1, 2.0)
	# Shoot
	var a = -PI * 0.05
	rotation.x = rand_range(-a, a)
	rotation.z = rand_range(-a, a)
	
	var rand_a = rand_range(0, PI * 2)
	var rand_r = rand_range(0, 1) * 10.0
	var off_x = cos(rand_a) * rand_r
	var off_y = sin(rand_a) * rand_r
	
	translation.x = off_x
	translation.z = off_y
	
	emit_signal("shoot", transform)
