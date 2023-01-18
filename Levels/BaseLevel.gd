extends Node3D

@export var autodetect_mode : bool
@export var show_debugger : bool

func _init():
	print("init")

func _ready() :
	if(autodetect_mode):
		# Launch XR if it can be initialized, otherwise launch flat
		print("Autodetecting XR or non-XR mode on whether a headset is connected...")
		var xr_interface := XRServer.find_interface("WebXR")
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
	$CanvasLayer/Launcher.launch_tps.connect(_on_launch_tps)
	
func _on_launch_xr() -> void:
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		var vp : Viewport = get_viewport()
		vp.use_xr = true
		
	var xrController = PlayerControlManager._instantiate_xr_controller()
	add_child(xrController)

func _on_launch_fps() -> void:
	var fpsController = PlayerControlManager._instantiate_fps_controller()
	add_child(fpsController)
	
func _on_launch_tps() -> void:
	# Add the ThirdPersonController to scene
	var tpsController = PlayerControlManager._instantiate_tps_controller()
	add_child(tpsController)

func _launch_debugger():
	var debuggerResource : Resource = load("res://UI/Debugger/Debugger.tscn")
	var debuggerInstance : Control = debuggerResource.instantiate()
	add_child(debuggerInstance)
