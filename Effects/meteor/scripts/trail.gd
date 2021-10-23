extends ImmediateGeometry
export(int) var resolution = 4
export(int) var trail_length = 16
export(int) var radius = 1
export(Curve) var profile

var points = []
var points_directions = []
var lines_directions = []
var vertices = []

export(NodePath) var target_path
var target

func _ready():
	target = get_node(target_path)
	# Populate points array for test purpose :) 
	for i in range(trail_length):
		points.append(Vector3(
			cos(-i * .2) * 2,
			0,
			sin(i * .2) * 2
		))

	for p_i in range(points.size()-1):
		var current_point = points[p_i]
		var next_point = points[p_i+1]
		lines_directions.append(current_point.direction_to(next_point))

	points_directions.append(lines_directions[0])
	for p_i in range(1,points.size()-1):
		var previous_direction = lines_directions[p_i-1]
		var next_direction = lines_directions[p_i]
		points_directions.append(previous_direction.slerp(next_direction, 0.5))
	points_directions.append(lines_directions[lines_directions.size()-1])
	
	
	for p_i in points.size():
		var center = points[p_i]
		var current_direction = points_directions[p_i]
		for i in resolution:
			var t = Transform().rotated(current_direction,(float(i)/resolution) * PI * 2 )
			var point_side = center + t.basis.y
			vertices.append(point_side)
			
			
func _process(delta):
	
	
	if(points[points.size()-1].distance_to(target.translation) < .4) : return
	
	points.remove(0) 
	points.append(target.translation)
	vertices.clear()
	
	lines_directions.remove(0)
	lines_directions.append(points[points.size()-2].direction_to(points[points.size()-1]))
	
	points_directions.remove(0)
	points_directions.append(lines_directions[lines_directions.size()-1])
	
	for p_i in points.size():
		var center = points[p_i]
		var current_direction = points_directions[p_i]
		for i in resolution:
			var t = Transform().rotated(current_direction,(float(i)/resolution) * PI * 2 )
			var point_side = center + t.basis.y * profile.interpolate(float(p_i)/points.size()) * radius
			vertices.append(point_side)
	
	
	display_mesh()
	
func display_mesh():
	clear()
	begin(Mesh.PRIMITIVE_TRIANGLES)
	for trail_id in trail_length - 1:
		var uv_y_1 = float(trail_id) / (trail_length - 1)
		var uv_y_2 = float(trail_id + 1) / (trail_length - 1)
		
		var current_point = points[trail_id]
		var next_point = points[trail_id + 1]
		
		for ring_id in resolution:
			
			
			var trail_offset = (trail_id * resolution)
			var next_trail_offset = ((trail_id + 1) * resolution)
			
			var uv_x_1 = float(ring_id) / (resolution)
			var uv_x_2 = float(ring_id + 1) / (resolution)
			set_uv(Vector2(uv_x_1,uv_y_1))
			set_normal(vertices[trail_offset + ring_id].direction_to(current_point))
			add_vertex(vertices[trail_offset + ring_id])
			set_uv(Vector2(uv_x_2,uv_y_1))
			add_vertex(vertices[trail_offset + ((ring_id + 1) % resolution)])
			set_uv(Vector2(uv_x_1,uv_y_2))
			add_vertex(vertices[next_trail_offset + ring_id])

			set_uv(Vector2(uv_x_2,uv_y_1))
			add_vertex(vertices[trail_offset + ((ring_id + 1) % resolution)])
			set_uv(Vector2(uv_x_2,uv_y_2))
			add_vertex(vertices[next_trail_offset + ((ring_id + 1) % resolution)])		
			set_uv(Vector2(uv_x_1,uv_y_2))
			add_vertex(vertices[next_trail_offset + ring_id])
	end()
