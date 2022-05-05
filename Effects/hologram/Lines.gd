extends ImmediateGeometry
tool
export(NodePath) var target_path
onready var target_node = get_node(target_path)
export(NodePath) var origin_path
onready var origin_node = get_node(origin_path)
var mdt

func _ready():
	mdt = MeshDataTool.new() 
	var m = target_node.get_mesh()
	mdt.create_from_surface(m, 0)

func _process(_delta):
	clear()
	begin(Mesh.PRIMITIVE_LINES)
	for pointID in mdt.get_vertex_count():
		var uv_x = pointID
		var vertex = mdt.get_vertex(pointID)
		add_vertex(origin_node.translation)
		set_uv(Vector2(uv_x, 1))
		add_vertex(target_node.global_transform.xform(vertex))
		set_uv(Vector2(uv_x, 0))
	end()
