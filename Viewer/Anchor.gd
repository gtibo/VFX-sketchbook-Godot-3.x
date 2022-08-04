extends Control

signal toggle

func _on_Anchor_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("toggle")
