@tool
class_name PlayerControlManager
extends CanvasLayer

signal launch_xr
signal launch_fps
signal launch_tps

enum XRType { NONE , WEBXR , OPENXR }
var supportedXR : XRType = XRType.NONE

var webxr_interface: WebXRInterface

# Handle auto-initialization when ready
func _ready() -> void:
	# Check for OpenXR interface
	_initialize_openxr()

	# Check for WebXR interface
	_initialize_webxr()


# Perform OpenXR setup
func _initialize_openxr():
	print("OpenXR: Configuring interface")
	var xr_interface = XRServer.find_interface('OpenXR')

	# Initialize the OpenXR interface
	if not xr_interface.is_initialized():
		print("OpenXR: Initializing interface")
		if not xr_interface.initialize():
			push_error("OpenXR: Failed to initialize")
			return false
			
	supportedXR = XRType.OPENXR
	$Panel/HBoxContainer/XR.text = "Play OpenXR"
	
func _initialize_webxr():
	print("WebXR: Configuring interface")
	var webxr_interface = XRServer.find_interface("WebXR")
	
	if webxr_interface:
		# Map to the standard button/axis ids when possible.
		webxr_interface.xr_standard_mapping = true
		# WebXR uses a lot of asynchronous callbacks, so we connect to various signals in order to receive them.
		webxr_interface.session_supported.connect(self._on_webxr_session_supported)
		webxr_interface.session_started.connect(func() : get_viewport().use_xr = true)
		webxr_interface.session_ended.connect(func() : get_viewport().use_xr = false)
		webxr_interface.session_failed.connect(func() : OS.alert("Unable to enter VR"))
		
		# This returns immediately - our _webxr_session_supported() method
		# (which we connected to the "session_supported" signal above) will
		# be called sometime later to let us know if it's supported or not.
		webxr_interface.is_session_supported("immersive-vr")
		
func _on_webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == "immersive-vr":
		if supported:
			supportedXR = XRType.WEBXR
			$Panel/HBoxContainer/XR.text = "Play WebXR"
		else:
			$Panel/HBoxContainer/XR.text = "The browser does not support WebXR"
			$Panel/HBoxContainer/XR.disabled = true

# Launch the Flat Scene
func launch_fps_button_pressed():
	self.launch_fps.emit()
	hide()
	
func launch_tps_button_pressed():
	self.launch_tps.emit()
	hide()

# Launch the XR scene
func launch_xr_button_pressed():
	
	hide()
	
	var vp : Viewport = get_viewport()
	vp.use_xr = true
	
	if(supportedXR == XRType.WEBXR):
		webxr_interface.session_mode = 'immersive-vr'
		webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
		webxr_interface.required_features = 'local-floor'
		webxr_interface.optional_features = 'bounded-floor'
		if not webxr_interface.initialize():
			OS.alert("Failed to initialize WebXR")

	self.launch_xr.emit()

	

