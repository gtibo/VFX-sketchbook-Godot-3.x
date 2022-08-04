extends fireball

onready var timer = $Timer
onready var particles = $Particles

var particles_color = Color.white

func remove():
	particles.emitting = false
	timer.start()
	yield(timer, "timeout")
	queue_free()
	
func _ready():
	particles.material_override = particles.material_override.duplicate()
	particles.material_override.emission = lerp(particles_color, Color.white, 0.7)

func set_particles_color(color : Color):
	particles_color = color

