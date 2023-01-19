@tool
class_name PlayerControlManager
extends CanvasLayer

signal launch_xr
signal launch_fps
signal launch_tps

enum XRMode { NONE , WEBXR , OPENXR }
var availableXRMode : XRMode = XRMode.NONE

# Launch the XR scene
func launch_xr_button_pressed():
	self.launch_xr.emit(availableXRMode)
	hide()
	
# Launch the Flat Scene
func launch_fps_button_pressed():
	self.launch_fps.emit()
	hide()
	
func launch_tps_button_pressed():
	self.launch_tps.emit()
	hide()

# Handle auto-initialization when ready
func _ready() -> void:
	# Check for OpenXR interface
	if (_try_initialize_openxr()):
		availableXRMode = XRMode.OPENXR
	# Check for WebXR interface
	elif XRServer.find_interface('WebXR'):
		availableXRMode = XRMode.WEBXR
	# Show only flatscreen if no XR interface available
	if(	availableXRMode == XRMode.NONE ) :
		print("No XRMode available")
		#$Panel/HBoxContainer/XR.visible = false

# Perform OpenXR setup
func _try_initialize_openxr() -> bool:
	print("OpenXR: Configuring interface")
	var xr_interface = XRServer.find_interface('OpenXR')

	# Initialize the OpenXR interface
	if not xr_interface.is_initialized():
		print("OpenXR: Initializing interface")
		if not xr_interface.initialize():
			push_error("OpenXR: Failed to initialize")
			return false
	return true
