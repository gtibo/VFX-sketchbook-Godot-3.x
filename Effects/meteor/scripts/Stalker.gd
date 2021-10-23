extends Spatial



export(NodePath) var targe_path
var target
var others = []

var max_speed = 15

var velocity = Vector3(0,0,0)
var zone_radius = 1
var size = 1

var old_pos

func _ready():
	add_to_group("stalker")
	target = get_node(targe_path)
	max_speed = rand_range(10,20)
	size = rand_range(0.05,.6)
	zone_radius = size * 3;
	$Head/Star.scale = Vector3(size,size,size) * .5

	$Zone/CollisionShape.shape = SphereShape.new()
	$Zone/CollisionShape.shape.radius = zone_radius


func _process(delta):

	var direction = translation.direction_to(target.translation)
	var distance = translation.distance_to(target.translation)
	var speed_offset = range_lerp(distance, 4, 0, 1, 0)
	
	$Head.look_at(direction, Vector3(0,1,0))
	
	velocity += direction * speed_offset
	
	var time = OS.get_ticks_msec() * .01
	# Separate
	for other in others:
		var direction_to_other = other.translation.direction_to(translation)
		var distance_to_other = other.translation.distance_to(translation)
		var radius = abs(zone_radius - other.zone_radius)
		var d = 1 - (radius/distance_to_other)
		d *= .5
		velocity += direction_to_other * d
		
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	translation += velocity * delta
	
	
func _on_Zone_area_entered(area):
	if area.get_parent().is_in_group("stalker"):
		others.append(area.get_parent())
	
func _on_Zone_area_exited(area):
	if area.get_parent().is_in_group("stalker"):
		var other_index = others.find(area.get_parent())
		if other_index != -1:
			others.remove(other_index)
