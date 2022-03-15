extends CSGBox

export(PackedScene) var projectile_scene
export(PackedScene) var follow_scene

onready var projectile_container = get_node("../Spatial")

func shoot(count):
	randomize()
	rotation.x = rand_range(-.2,.2)
	rotation.z = rand_range(-.2,.2)
	
	var p = projectile_scene.instance()
	p.translation = translation + transform.basis.y
	p.velocity = transform.basis.y * rand_range(10,20)
	projectile_container.add_child(p)
	var r = count
	for i in range(r):
		var f = follow_scene.instance()
		f.translation = translation
		f.translation.x += rand_range(-.2,.2)
		f.translation.y += rand_range(-.2,.2)
		f.translation.z += rand_range(-.2,.2)
		f.target = p
		projectile_container.add_child(f)


func _on_Button_pressed():
	shoot(8)
func _on_2_pressed():
	shoot(24)
func _on_3_pressed():
	shoot(48)
