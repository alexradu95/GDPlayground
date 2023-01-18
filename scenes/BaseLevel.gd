extends Node3D

@export var autodetect_mode : bool
@export var show_debugger : bool

## User setting for WebXR primary
@export_enum(WebXRPrimary) var webxr_primary : int = WebXRPrimary.AUTO: set = set_webxr_primary

## Records the first input to generate input (thumbstick or trackpad).
var webxr_auto_primary := 0

## Emitted when the WebXR primary is changed (either by the user or auto detected).
signal webxr_primary_changed (value)

enum WebXRPrimary {
	AUTO,
	THUMBSTICK,
	TRACKPAD,
}

const WebXRPrimaryName := {
	WebXRPrimary.AUTO: "auto",
	WebXRPrimary.THUMBSTICK: "thumbstick",
	WebXRPrimary.TRACKPAD: "trackpad",
}

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
	
	
	var openxr_interface: XRInterface = XRServer.find_interface("OpenXR")
	var webxr_interface: XRInterface = XRServer.find_interface("WebXR") 
	
	if webxr_interface:
		instantiate_webxr(webxr_interface)
	
	if openxr_interface and openxr_interface.is_initialized():
		get_viewport().use_xr = true

		
	var xrController = PlayerControlManager._instantiate_xr_controller()
	add_child(xrController)

func instantiate_webxr(webxr_interface) -> void:
	XRServer.tracker_added.connect(self._on_webxr_tracker_added)
	webxr_interface.session_supported.connect(self._on_webxr_session_supported)
	webxr_interface.session_started.connect(self._on_webxr_session_started)
	webxr_interface.session_ended.connect(self._on_webxr_session_ended)
	webxr_interface.session_failed.connect(self._on_webxr_session_failed)
	webxr_interface.is_session_supported("immersive-vr")
	
	webxr_interface.session_mode = 'immersive-vr'
	webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
	webxr_interface.required_features = 'local-floor'
	webxr_interface.optional_features = 'bounded-floor'

	if not webxr_interface.initialize():
		OS.alert("Failed to initialize WebXR")
		

## Set the WebXR primary
func set_webxr_primary(new_value : int) -> void:
	webxr_primary = new_value
	if webxr_primary == WebXRPrimary.AUTO:
		if webxr_auto_primary == 0:
			# Don't emit the signal yet, wait until we detect which to use.
			pass
		else:
			webxr_primary_changed.emit(webxr_auto_primary)
	else:
		webxr_primary_changed.emit(webxr_primary)
		
## Gets the WebXR primary (taking into account auto detection).
func get_real_webxr_primary() -> int:
	if webxr_primary == WebXRPrimary.AUTO:
		return webxr_auto_primary
	return webxr_primary
		
## Used to connect to tracker events when using WebXR.
func _on_webxr_tracker_added(tracker_name: StringName, type: int) -> void:
	if tracker_name == &"left_hand" or tracker_name == &"right_hand":
		var tracker := XRServer.get_tracker(tracker_name)
		tracker.input_axis_changed.connect(self._on_webxr_axis_changed)
		
## Used to auto detect which "primary" input gets used first.
func _on_webxr_axis_changed(name: String, vector: Vector2) -> void:
	if webxr_auto_primary == 0:
		if name == "thumbstick":
			webxr_auto_primary = WebXRPrimary.THUMBSTICK
		elif name == "trackpad":
			webxr_auto_primary = WebXRPrimary.TRACKPAD

		if webxr_auto_primary != 0:
			# Let the developer know which one is chosen.
			webxr_primary_changed.emit(webxr_auto_primary)

func _on_webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == "immersive-vr":
		if supported:
			visible = true
		else:
			OS.alert("Your web browser doesn't support VR. Sorry!")

func _on_webxr_session_started() -> void:
	visible = false
	get_viewport().use_xr = true


func _on_webxr_session_ended() -> void:
	visible = true
	get_viewport().use_xr = false


func _on_webxr_session_failed(message: String) -> void:
	OS.alert("Unable to enter VR: " + message)
	visible = true


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
	
	
	
	
