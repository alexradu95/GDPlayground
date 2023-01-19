extends Node

##
## XR / Flat Mode Autoload Singleton
##
## The script provides a means for the "What mode are we in" question
## to be asked from anywhere. Expected to use a Node name of "XrOrFlatMode".
##


func _instantiate_xr_controller() -> Node3D:
	var xrControllerResource = load("res://players/xr_first_person/XRController.tscn")
	return xrControllerResource.instantiate()

func _instantiate_fps_controller() -> Node3D:
	var fpsControllerResource : Resource = load("res://players/flat_first_person/FPSController.tscn")
	return fpsControllerResource.instantiate()
	
func _instantiate_tps_controller() -> Node3D:
	var fpsControllerResource : Resource = load("res://players/flat_3rd_person/ThirdPersonController.tscn")
	return fpsControllerResource.instantiate()

