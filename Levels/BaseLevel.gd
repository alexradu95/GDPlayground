extends Node3D

func _init():
	pass

func _ready() :
	$Launcher.launch_xr.connect(_on_launch_xr)
	$Launcher.launch_fps.connect(_on_launch_fps)


func _on_launch_xr() -> void:
	print("XR Mode Active")
	# Add the XROrigin3D to scene
	var xrControllerResource = load("res://Mode/VirtualReality/XROrigin3D.tscn")
	var xrController = xrControllerResource.instantiate()
	add_child(xrController)

# Launch the Flat Scene
func _on_launch_fps() -> void:
	print("Standard Non-XR Mode Active")
	# Add the FirstPersonController to scene
	var fpsControllerResource : Resource = load("res://Mode/FlatScreen/FPSController.tscn")
	var fpsController : Node3D = fpsControllerResource.instantiate()
	add_child(fpsController)
