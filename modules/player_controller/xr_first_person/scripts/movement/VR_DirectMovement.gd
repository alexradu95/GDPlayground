extends XRController3D

# A constant to define the dead zone for both the trackpad and the joystick.
# See (http://www.third-helix.com/2013/04/12/doing-thumbstick-dead-zones-right.html)
# for more information on what dead zones are, and how we are using them in this project.
#
# The deadzone defined below is large so little bumps on the trackpad/joystick do not move the player.
const CONTROLLER_DEADZONE = 0.65

# A constant to define the speed the player moves at when using the touchpad/joystick.
const MOVEMENT_SPEED = 1.5
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_physics_process_directional_movement(delta)

# This function handles moving the player when the joystick/touchpad is changed.
func _physics_process_directional_movement(delta):

	# We retrieve the input from the thumbstick
	var movement_vector = self.get_axis("primary").normalized()
	
	# If the trackpad_vector's length is less than CONTROLLER_DEADZONE, then just ignore the input entirely.
	if movement_vector.length() < CONTROLLER_DEADZONE:
		movement_vector = Vector2(0,0)
	# If the trackpad_vector's length is not less than CONTROLLER_DEADZONE, then process the input
	# while accounting for the deadzones within the controller.
	else:
		# (See the link at CONTROLLER_DEADZONE for an explanation of how this code works!)
		movement_vector = movement_vector * ((movement_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))
	# Get the forward and right direction vectors relative to the global transform of the player camera.
	# What this does is that it gives us vectors that point forward and right relative to the rotation
	# of the player camera.
	# We can use this to move relative to the rotation of the player camera, so that when you push forward
	# on the joystick/trackpad, you move in the direction that the player camera is facing.
	var forward_direction = get_parent().get_node("XRCamera3D").global_transform.basis.z.normalized()
	var right_direction = get_parent().get_node("XRCamera3D").global_transform.basis.x.normalized()
	
	# Calculate the amount of movement the player will take on the Z (forward) axis and assign it to movement_forward.
	var movement_forward = -forward_direction * movement_vector.y * delta * MOVEMENT_SPEED
	# Calculate the amount of movement the player will take on the X (right) axis and assign it to movement_forward.
	var movement_right = right_direction * movement_vector.x * delta * MOVEMENT_SPEED
	
	# Remove any movement on the Y axis so the player will not be able to fly/fall just by moving the trackpad/joystick.
	movement_forward.y = 0
	movement_right.y = 0
	
	# If there is movement to apply in either movement_right or movement_forward...
	if (movement_right.length() > 0 or movement_forward.length() > 0):
		# Move the ARVR node (which is assumed to be the parent node) in the direction the player is pushing
		# the trackpad/joystick towards.
		get_parent().global_translate(movement_right + movement_forward)
