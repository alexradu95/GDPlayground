extends Node

enum xrType { NONE, WEBXR, OPENXR}
var supportedXR: xrType = xrType.NONE

# Launch the XR scene
func _on_xr_button_pressed():
	print("Launch XR button pressed")
	
	if(supportedXR == xrType.OPENXR):
		_initialize_openxr()
	elif(supportedXR == xrType.WEBXR):
		_initialize_webxr()
	
	get_viewport().use_xr = true;
	
	_inject_xr_fps()
	
func _on_fps_button_pressed():
	$PlayerControlUI.hide()
	print("Launch FPS button pressed")
	_inject_flat_fps()

func _on_tps_button_pressed():
	print("Launch TPS button pressed")
	_inject_flat_tps()
	$PlayerControlUI.hide()
	
func _on_free_look_button_pressed():
	print("Launch Free look button pressed")
	_inject_free_look_camera()
	$PlayerControlUI.hide()
	
func _initialize_webxr():
	var webxr_interface = XRServer.find_interface("WebXR")
	if webxr_interface.initialize():
		print("WebXR Interface initialized succesfully")
		$PlayerControlUI.hide()
	else:
		print("Failed to initialize WebXR")
		
func _initialize_openxr():
	var openxr_interface = XRServer.find_interface("OpenXR")
	# Initialize the OpenXR interface
	if not openxr_interface.is_initialized():
		print("OpenXR: Initializing interface")
		if openxr_interface.initialize():
			print("OpenXR: Initialized succesfully")
		else:
			print("OpenXR: Failed to initialize")
	else:
		print("OpenXR: Already initialized")
		
func _on_web_xr_availability(webXrAvailability: bool):
	if(webXrAvailability):
		print("WebXR Interface is available")
		supportedXR = xrType.WEBXR
		$PlayerControlUI/Panel/HBoxContainer/VBoxContainer/XR_Button.disabled = false
		$PlayerControlUI/Panel/HBoxContainer/VBoxContainer/XR_Button.set_text("WebXR")

func _on_open_xr_availability(openXrAvailability : bool):
	if(openXrAvailability):
		print("OpenXR Interface is available")
		supportedXR = xrType.OPENXR
		$PlayerControlUI/Panel/HBoxContainer/VBoxContainer/XR_Button.disabled = false
		$PlayerControlUI/Panel/HBoxContainer/VBoxContainer/XR_Button.set_text("OpenXR")
		
func _inject_flat_fps():
	var fpsControllerResource : Resource = load("res://modules/player_controller/fps_controller/fps_controller.tscn")
	var fpsController = fpsControllerResource.instantiate()
	
	var currentScene = get_tree().current_scene
	currentScene.add_child(fpsController)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _inject_flat_tps():
	var tpsControllerResource : Resource = load("res://modules/player_controller/tps_controller/tps_controller.tscn")
	var thirdPersonCamera = tpsControllerResource.instantiate()
	self.add_child(thirdPersonCamera)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _inject_xr_fps():
	var xrControllerResource = load("res://modules/player_controller/xr_controller/xr_controller.tscn")
	var xrControllerCamera =  xrControllerResource.instantiate()
	self.add_child(xrControllerCamera)


func _inject_free_look_camera():
	var freeLookCameraResource = load("res://addons/free-look-camera/free_look_camera.tscn")
	var freeLookCamera =  freeLookCameraResource.instantiate()
	self.add_child(freeLookCamera)
