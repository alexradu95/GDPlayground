extends "res://modules/player_controller/base_controller/base_player_controller.gd"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	toggle_mouse_capture()

func toggle_mouse_capture():
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _input(event):
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		_rotate_camera_on_mouse_motion(event)

func _rotate_camera_on_mouse_motion(event):
	# We rotate the Node on it's Y axis
	rotate_y(-event.relative.x * 0.05)
	# We rotate the Camera on X axis in order to not mess with the controls
	$Camera3D.rotate_x(-event.relative.y * 0.05)
	# We clamp the rotation in order to not rotate indifently on vertical axis
	rotation.x = clamp(rotation.x, -PI/2, PI/2)
