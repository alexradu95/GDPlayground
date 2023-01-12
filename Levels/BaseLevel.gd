extends Node3D

@export var autodetect_mode : bool

func _init():
	pass
	
func _process(delta):
	toggle_mouse_capture()

func _ready() :
	if(autodetect_mode):
		# Launch XR if it can be initialized, otherwise launch flat
		print("Autodetecting XR or non-XR mode on whether a headset is connected...")
		var xr_interface := XRServer.find_interface("OpenXR")
		if xr_interface and xr_interface.initialize():
			_on_launch_xr()
		else:
			_on_launch_fps()
	else:
		$CanvasLayer/Launcher.show()
		_connect_signals()

func _connect_signals() :
	$CanvasLayer/Launcher.launch_xr.connect(_on_launch_xr)
	$CanvasLayer/Launcher.launch_fps.connect(_on_launch_fps)
	$CanvasLayer/Launcher.launch_fps.connect(_on_launch_fps)
	
func toggle_mouse_capture():
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _on_launch_xr() -> void:
	print("XR Mode Active")
	# Add the XROrigin3D to scene
	var xrControllerResource = load("res://Mode/XRMode/XRController/XROrigin3D.tscn")
	var xrController = xrControllerResource.instantiate()
	add_child(xrController)

# Launch the Flat Scene
func _on_launch_fps() -> void:
	print("Standard Non-XR Mode Active | FPS MODE")
	# Add the FirstPersonController to scene
	var fpsControllerResource : Resource = load("res://Mode/FlatMode/FPSController/FPSController.tscn")
	var fpsController : Node3D = fpsControllerResource.instantiate()
	add_child(fpsController)
	
# Launch the Flat Scene
func _on_launch_tps() -> void:
	print("Standard Non-XR Mode Active | TPS MODE")
	# Add the FirstPersonController to scene
	var fpsControllerResource : Resource = load("res://Mode/FlatMode/3rdPersonController/ThirdPersonController.tscn")
	var fpsController : Node3D = fpsControllerResource.instantiate()
	add_child(fpsController)
