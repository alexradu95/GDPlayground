extends Node

##
## XR / Flat Mode Autoload Singleton
##
## The script provides a means for the "What mode are we in" question
## to be asked from anywhere. Expected to use a Node name of "XrOrFlatMode".
##


func _instantiate_xr_controller() -> Node3D:
	var xrControllerResource = load("res://Mode/XRMode/XRController/XROrigin3D.tscn")
	return xrControllerResource.instantiate()

func _instantiate_fps_controller() -> Node3D:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var fpsControllerResource : Resource = load("res://Mode/FlatMode/FPSController/FPSController.tscn")
	return fpsControllerResource.instantiate()
	
func _instantiate_tps_controller() -> Node3D:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var fpsControllerResource : Resource = load("res://Mode/FlatMode/3rdPersonController/ThirdPersonController.tscn")
	return fpsControllerResource.instantiate()

