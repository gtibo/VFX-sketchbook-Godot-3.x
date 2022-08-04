extends Spatial
class_name fireball

export(Material) var trail_mat
var gravity = Vector3(0, -5, 0)
var velocity = Vector3.ZERO

onready var tween = $Tween
onready var trail = $Trail

func _ready():
	tween.interpolate_method(self, "interpolate", 0.0, 1.0, 1.5 * rand_range(0.8, 1.2))
	tween.start()
	trail.material_override = trail_mat.duplicate()
	yield(tween, "tween_completed")
	remove()
	
func setup(origin : Vector3, direction : Vector3, speed : float):
	translation = origin
	velocity = direction * speed

func _physics_process(delta):
	velocity += gravity * delta
	velocity = lerp(velocity, Vector3.ZERO, 2.0 * delta)
	translation += velocity * delta

func interpolate(t):
	if t >= 0.7:
		var a = range_lerp(t, 0.7, 1.0, 1.0, 0.0)
		trail.material_override.set_shader_param("alpha", a)

func remove():
	queue_free()
