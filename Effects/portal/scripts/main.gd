extends Spatial


func _ready():
	$Viewport.size = get_viewport().size
	

func _process(delta):
	var time = OS.get_ticks_msec() * .0006
	$Camera.translation.x = cos(time*.8) * 6
	$Camera.translation.y = .5 + cos(time * .2) * .5
	$Camera.translation.z = sin(time*.7) * 6
	$Camera.look_at($Portal.translation, Vector3(0,1,0))
	
	$Viewport/CameraTarget.translation = $Target.translation + $Camera.translation 
	$Viewport/CameraTarget.rotation = $Camera.rotation
