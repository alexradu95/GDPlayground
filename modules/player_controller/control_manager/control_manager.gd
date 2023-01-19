@tool
class_name PlayerControlManager
extends CanvasLayer

@export var autoxr : bool

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
	var xr_interface : OpenXRInterface = XRServer.find_interface('OpenXR')
	if xr_interface:
		print("OpenXR: XRInterace Available")
		# Initialize the OpenXR interface
		if not xr_interface.is_initialized():
			print("OpenXR: Initializing interface")
			if xr_interface.initialize():
				print("OpenXR: Initialized succesfully")
				supportedXR = XRType.OPENXR
				$Panel/HBoxContainer/XR.set_text("Play OpenXR")
			else:
				print("OpenXR: Failed to initialize")
		else:
			print("OpenXR: Initialized succesfully")
			supportedXR = XRType.OPENXR
			$Panel/HBoxContainer/XR.set_text("Play OpenXR")
	else:
		print("OpenXR: Could not find OpenXR Interface")

func _initialize_webxr():
	print("WebXR: Configuring interface")
	webxr_interface = XRServer.find_interface("WebXR")
	
	if webxr_interface:
		print("WebXR: webxr_interface found")
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
	else:
		print("WebXR: Could not find WebXR Interface")
		
func _on_webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == "immersive-vr":
		if supported:
			print("WebXR: immersive-vr is supported")
			supportedXR = XRType.WEBXR
			$Panel/HBoxContainer/XR.set_text("Play WebXR")
		else:
			print("WebXR: immersive-vr not supported supported")
			$Panel/HBoxContainer/XR.set_text("The browser does not support WebXR")
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
	if(supportedXR == XRType.WEBXR):
		# We want an immersive VR session, as opposed to AR ('immersive-ar') or a
		# simple 3DoF viewer ('viewer').
		webxr_interface.session_mode = 'immersive-vr'
		# 'bounded-floor' is room scale, 'local-floor' is a standing or sitting
		# experience (it puts you 1.6m above the ground if you have 3DoF headset),
		# whereas as 'local' puts you down at the XROrigin.
		# This list means it'll first try to request 'bounded-floor', then
		# fallback on 'local-floor' and ultimately 'local', if nothing else is
		# supported.
		webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
		# In order to use 'local-floor' or 'bounded-floor' we must also
		# mark the features as required or optional.
		webxr_interface.required_features = 'local-floor'
		webxr_interface.optional_features = 'bounded-floor'
		if not webxr_interface.initialize():
			OS.alert("Failed to initialize WebXR")
			
	var vp : Viewport = get_viewport()
	vp.use_xr = true

	self.launch_xr.emit()

