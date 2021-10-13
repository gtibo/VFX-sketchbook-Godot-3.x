extends Path

func _ready():
	start_tween()

func start_tween():
	$Tween.interpolate_property($PathFollow, "unit_offset", 0, 1, 10)
	$Tween.start()

func _on_Tween_tween_all_completed():
	start_tween()
