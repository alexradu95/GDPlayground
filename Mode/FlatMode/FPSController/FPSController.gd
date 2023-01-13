extends BaseCharacterBodyController

func _process(delta):
	toggle_mouse_capture()

func _physics_process(delta):
	handle_movement(delta)
	handle_jumping(delta)
	move_and_slide()
	
# This is called everytime there is any kind input:
func _input(event):
	# There are many types of inputs, so we must specify what we listen to
	if event is InputEventMouseMotion:
		_rotate_camera_on_mouse_motion(event)

func _rotate_camera_on_mouse_motion(event):
	# We rotate the Node on it's Y axis
	rotate_y(-event.relative.x * mouse_sensitivity)
	# We rotate the Camera on X axis in order to not mess with the controls
	$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
	# We clamp the rotation in order to not rotate indifently on vertical axis
	$Camera3D.rotation.x = clamp($Camera3D.rotation.x, -PI/2, PI/2)
