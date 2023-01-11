extends Node3D


signal launch_xr
signal launch_fps


func _ready() :
	get_tree().paused = true

func _on_launch_xr() -> void:
	print("XR Mode Active")
	# Add the XROrigin3D to scene
	var xrControllerResource = load("res://Mode/VirtualReality/XROrigin3D.tscn")
	var xrController = xrControllerResource.instantiate()
	add_child(xrController);
	get_tree().paused = false


# Launch the Flat Scene
func _on_launch_fps() -> void:
	print("Standard Non-XR Mode Active")
	# Add the FirstPersonController to scene
	var fpsControllerResource : Resource = load("res://Mode/FlatScreen/FPSController.tscn")
	var fpsController : Node3D = fpsControllerResource.instantiate()
	add_child(fpsController);
	get_tree().paused = false

