extends Spatial

export var direction : Vector3 = Vector3(0, 1.0, 0)
export(Material) var trail_mat

onready var timer = $Timer
onready var anchor = $Anchor
onready var tween : Tween = $Tween
onready var trail = $Anchor/Trail3D
onready var particles = $Anchor/Particles

var altitude = rand_range(25, 40)
var start = Vector3.ZERO
var target = Vector3.ZERO

var r = rand_range(0.1, 1.0)
var twirl = 40 * r
var offset = 0.4 * r


signal explode

func setup(t : Transform, theme : firework_theme):
	particles.material_override = particles.material_override.duplicate()
	particles.material_override.emission = lerp(theme.first_color, Color.white, 0.7)
	translation = t.origin
	direction = t.basis.y
	anchor.transform.basis.y = direction
	
	start = translation
	target = translation + direction * altitude
	tween.interpolate_method(self, "interpolate", 0.0, 1.0, rand_range(0.8, 1.5), Tween.TRANS_CIRC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("explode", transform)
	particles.emitting = false
	timer.start()
	yield(timer, "timeout")
	queue_free()

func _ready():
	trail.material_override = trail_mat.duplicate()

func interpolate(t):
	translation = start.linear_interpolate(target ,t)
	anchor.translation.x = cos(t * twirl) * offset * t
	anchor.translation.z = sin(t * twirl) * offset * t
	if t >= 0.9:
		var a = range_lerp(t, 0.9, 1.0, 1.0, 0.0)
		trail.material_override.set_shader_param("alpha", a)
