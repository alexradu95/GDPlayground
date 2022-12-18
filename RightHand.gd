extends XRController3D

var rotating_silent: float
var rotating_speed: float =  PI/12

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_physics_process_rotate_player(delta)

# This function handles moving the player when the joystick/touchpad is changed.
func _physics_process_rotate_player(delta):
	# We retrieve the input from the thumbstick
	var rotation_value = self.get_axis("primary").x
	
	if self.rotating_silent <= 0:
		self.rotating_silent = 0.5
		if rotation_value > 0.3:
			get_parent().rotate(Vector3(0,1,0), -self.rotating_speed)
		elif rotation_value < -0.3:
			get_parent().rotate(Vector3(0,1,0), self.rotating_speed)
				
	self.rotating_silent-= delta
