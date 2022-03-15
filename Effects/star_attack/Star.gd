extends Area

var target : Spatial
var velocity : Vector3 = Vector3.ZERO

export(PackedScene) var impact


var max_speed = 10
var max_distance = 1

var zone_radius = 1
var others = []

var collided = false

func _ready():
	
	max_speed *= rand_range(.8,2)
	$CollisionShape.shape = SphereShape.new()
	zone_radius *= rand_range(.1,.8)

	
	$CollisionShape.shape.radius = zone_radius
	$Head.mesh = $Head.mesh.duplicate()
	$Head.mesh.size *= zone_radius
	$Trail3D.base_width = zone_radius * .2

func _physics_process(delta):
	var direction = translation.direction_to(target.translation)
	var dist = translation.distance_to(target.translation)
	dist = clamp(dist,0,max_distance)
	velocity += direction * range_lerp(dist, 0,max_distance, 0.5,1)
	
	# Separate
	for other in others:
		var direction_to_other = other.translation.direction_to(translation)
		var distance_to_other = other.translation.distance_to(translation)
		var radius = abs(zone_radius - other.zone_radius)
		var d = 1 - (radius/distance_to_other)
		d *= .6
		velocity += direction_to_other * d
	
	if(velocity.length() > max_speed):
		velocity = velocity.normalized() * max_speed

	translation += velocity * delta
	
	if translation.y < 0 && !collided:
		collided = true
		var i = impact.instance()
		i.scale *= zone_radius *.5
		i.translation = translation
		get_parent().add_child(i)
		
	if translation.y < -4:
		queue_free()

func _on_Area_area_entered(area):
	if area.is_in_group("stalker"):
		others.append(area)

func _on_Area_area_exited(area):
	if area.is_in_group("stalker"):
		var other_index = others.find(area)
		if other_index != -1:
			others.remove(other_index)
