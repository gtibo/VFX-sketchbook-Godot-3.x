extends Spatial

func _ready():

	$impact.material_override = $impact.material_override.duplicate()
	$impact_top.material_override = $impact_top.material_override.duplicate()
	$impact_top.material_override.set_shader_param("OffsetX", translation.x)
	$impact_top.material_override.set_shader_param("OffsetY", translation.y)
	
	$AnimationPlayer.play("Idle")

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
