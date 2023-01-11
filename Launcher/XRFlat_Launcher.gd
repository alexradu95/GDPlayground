class_name XrOrFlatModeLauncher
extends Node

##
## XR / Flat Mode Game Launcher
##
## The script launches the game in either flat or xr modes
##

# Launch the XR scene
func launch_xr() -> void:
	print("XR Mode Active")
	# Add the XROrigin3D to scene
	var xrControllerResource = load("res://Mode/VirtualReality/XROrigin3D.tscn")
	var xrController = xrControllerResource.instantiate()
	get_parent().add_child(xrController);
	self.hide()


# Launch the Flat Scene
func launch_flat() -> void:
	print("Standard Non-XR Mode Active")
	# Add the FirstPersonController to scene
	var fpsControllerResource = load("res://Mode/FlatScreen/FPSController.tscn")
	var fpsController = fpsControllerResource.instantiate()
	get_parent().add_child(fpsController);
	self.hide()
