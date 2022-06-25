extends Spatial

var others = []
var zone_radius = 1
export (float, 0, 1.0) var friction = 1
var velocity = Vector3(-1,-1,0)
var target : Spatial = null 
var target_offset = Vector3.ZERO
var max_distance = 2
var fear_level = 1.0 * rand_range(.4,3)
var speed = rand_range(1,3)
var min_speed = speed * .1
var max_speed = speed * 2
var size = rand_range(.6,1.8)
var is_visible = true
var wing_offset = rand_range(0,100)

export var wing_material : Material
var top_wing_material : Material
var bottom_wing_material : Material
var current_direction : Vector3 = Vector3.ONE

func _ready():
	top_wing_material = wing_material.duplicate()
	bottom_wing_material = wing_material.duplicate()
	top_wing_material.set_shader_param("TimeOffset", wing_offset)
	bottom_wing_material.set_shader_param("TimeOffset", wing_offset + 0.04)
	top_wing_material.set_shader_param("FlapSpeed", 15)
	bottom_wing_material.set_shader_param("FlapSpeed", 15)
	$Body/butterfly.set_surface_material(0, top_wing_material.duplicate())
	$Body/butterfly.set_surface_material(1, bottom_wing_material.duplicate())
	zone_radius = .2 * size
	$Body.scale = Vector3.ONE * size * 1.5
	$Zone/ZoneShape.shape = SphereShape.new()
	$Zone/ZoneShape.shape.radius = zone_radius

func set_visibility(value):
	is_visible = value
	if is_visible:
		$AnimationPlayer.play("Appear")
	else:
		$AnimationPlayer.play_backwards("Appear")

func _physics_process(delta):
	if is_visible:
		flight_behavior(delta)
	else:
		land_behavior(delta)

func land_behavior(delta):
	translation = translation.linear_interpolate(target.global_transform.origin + target_offset, 10 * delta)

func flight_behavior(delta):
	velocity += separation_force() * 8 * fear_level *  delta
	if target != null:
		velocity += crave_force() * 10 * delta
	velocity = velocity.linear_interpolate(Vector3.ZERO, friction * delta)
	var velocity_length = velocity.length()
	if velocity_length < min_speed:
		velocity = velocity.normalized() * min_speed
	if velocity_length > max_speed:
		velocity = velocity.normalized() * max_speed
	translation += velocity * delta
	var flap_speed = range_lerp(velocity_length, min_speed, max_speed, 0.1,1.1)
	top_wing_material.set_shader_param("FlapSpeed", 10 * flap_speed)
	bottom_wing_material.set_shader_param("FlapSpeed", 10 * flap_speed)
	var target_direction = global_transform.origin + velocity
	var diff_direction = target_direction - current_direction
	current_direction += diff_direction * 0.1
	$Body.look_at(current_direction,Vector3(0,1,0))
	
func crave_force():
	var t = target.global_transform.origin  + target_offset
	var direction = translation.direction_to(t)
	var dist = translation.distance_to(t)
	dist = clamp(dist,0,max_distance)
	return direction * range_lerp(dist, max_distance * .2, max_distance * 1.2, 0,1)

func separation_force():
	var force = Vector3.ZERO
	var others = $Zone.get_overlapping_areas()
	for other in others:
		other = other.owner
		var direction_to_other = other.translation.direction_to(translation)
		var distance_to_other = other.translation.distance_to(translation)
		var radius = abs(zone_radius - other.zone_radius)
		var d = 1 - (radius/distance_to_other)
		d *= .6
		force += direction_to_other * d
	if force.length() > 0:
		force /= others.size()
	return force
