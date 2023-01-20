extends Node

signal webXRAvailability

var webxr_interface: WebXRInterface

# Called when the node enters the scene tree for the first time.
func _ready():
	print("WebXR: Configuring interface")
	webxr_interface = XRServer.find_interface("WebXR")
	
	if webxr_interface:
		print("WebXR: webxr_interface found")
		
		# We want an immersive VR session, as opposed to AR ('immersive-ar') or a
		# simple 3DoF viewer ('viewer').
		webxr_interface.session_mode = 'immersive-vr'
		
		# 'bounded-floor' is room scale, 'local-floor' is a standing or sitting
		# experience (it puts you 1.6m above the ground if you have 3DoF headset),
		# whereas as 'local' puts you down at the XROrigin.
		# This list means it'll first try to request 'bounded-floor', then
		# fallback on 'local-floor' and ultimately 'local', if nothing else is supported.
		webxr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
		
		# In order to use 'local-floor' or 'bounded-floor' we must also
		# mark the features as required or optional.
		webxr_interface.required_features = 'local-floor'
		webxr_interface.optional_features = 'bounded-floor'
		
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
		webXRAvailability.emit(false)

func _on_webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == "immersive-vr":
		if supported:
			webXRAvailability.emit(true)
			print("WebXR: immersive-vr is supported")
		else:
			webXRAvailability.emit(false)
			print("WebXR: immersive-vr not supported supported")

