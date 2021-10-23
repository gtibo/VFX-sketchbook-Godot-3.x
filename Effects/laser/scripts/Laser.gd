extends Spatial

export(NodePath) var target_path
var target

func _ready():
	target = get_node(target_path)

func _physics_process(delta):
	$Body.look_at(target.translation, Vector3(0,-1,0))
	translation.angle_to(target.translation)
	$RayCast.cast_to = to_local(target.translation)
	#$RayCast.force_raycast_update()
	var point = $RayCast.get_collision_point()
	var normal = $RayCast.get_collision_normal()
	var laser_length = translation.distance_to(point)
	$light.translation = to_local(point.slerp(translation,.1))
	$Impact.translation = to_local(point)
	$Impact.look_at(translation, Vector3(0,-1,0))
	$Body/Container/Inner.scale.y = (laser_length)/2
	$Body/Container/Outer.scale.y = (laser_length)/2
	#$Body/Container/Inner.mesh.set_height(laser_length)
	#$Body/Container/Outer.mesh.set_height(laser_length)
	$Body/Container.translation.z  = -laser_length/2
