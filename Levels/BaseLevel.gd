extends Node3D

@export var autodetect_mode : bool
@export var show_debugger : bool

func _init():
	pass

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
		_connect_signals()
		$CanvasLayer/Launcher.show()

func _connect_signals() :
	$CanvasLayer/Launcher.launch_xr.connect(_on_launch_xr)
	$CanvasLayer/Launcher.launch_fps.connect(_on_launch_fps)
	$CanvasLayer/Launcher.launch_fps.connect(_on_launch_fps)
	
func _on_launch_xr() -> void:
	print("XR Mode Active")
	# Add the XROrigin3D to scene
	var xrControllerResource = load("res://Mode/XRMode/XRController/XROrigin3D.tscn")
	var xrController = xrControllerResource.instantiate()
	add_child(xrController)
	if(show_debugger):
		_launch_debugger()

# Launch the Flat Scene
func _on_launch_fps() -> void:
	print("Standard Non-XR Mode Active | FPS MODE")
	# Add the FirstPersonController to scene
	var fpsControllerResource : Resource = load("res://Mode/FlatMode/FPSController/FPSController.tscn")
	var fpsController : Node3D = fpsControllerResource.instantiate()
	add_child(fpsController)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if(show_debugger):
		_launch_debugger()
	
# Launch the Flat Scene
func _on_launch_tps() -> void:
	print("Standard Non-XR Mode Active | TPS MODE")
	# Add the FirstPersonController to scene
	var fpsControllerResource : Resource = load("res://Mode/FlatMode/3rdPersonController/ThirdPersonController.tscn")
	var fpsController : Node3D = fpsControllerResource.instantiate()
	add_child(fpsController)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if(show_debugger):
		_launch_debugger()

func _launch_debugger():
	print("Launching debugger")
	# Add the FirstPersonController to scene
	var debuggerResource : Resource = load("res://UI/Debugger/Debugger.tscn")
	var debuggerInstance : Control = debuggerResource.instantiate()
	add_child(debuggerInstance)
