extends Node

export(PackedScene) var projectile
export(NodePath) onready var holder = get_node(holder)
export(PackedScene) var explosion

export(Material) var trail_mat
export(Array, Resource) var themes

signal emit_light(color)

func shoot(transform : Transform):
	var theme = themes[randi() % themes.size()]
	
	var mat : ShaderMaterial = trail_mat.duplicate()
	mat.set_shader_param("first_color", theme.first_color)
	mat.set_shader_param("second_color", theme.second_color)
	
	var p = projectile.instance()
	p.trail_mat = mat
	holder.add_child(p)
	p.setup(transform, theme)
	var t = yield(p, "explode")
	
	var e = explosion.instance()
	holder.add_child(e)
	e.setup(t, mat, theme)
	emit_signal("emit_light", lerp(theme.first_color, theme.second_color, 0.5))
