@tool
extends BaseCharacterBodyController

func _physics_process(delta):
	_sync_body_rotation_with_camera()
		
func _process_on_player_input(delta):
	handle_jumping(delta)
	handle_movement(delta)

# Rotates the player to face the same way our real player is
func _sync_body_rotation_with_camera():
	# Start by rotating the player to face the same way our real player is
	# We retrieve camera_basis values
	# This is how it's calculated. If you want to get to the global position of an object
	# You will have to multiply parents until you get the Main node
	# Basis is the 3x3 used for 3D rotation and scale
	var camera_basis : Basis = $XROrigin3D.transform.basis * $XROrigin3D/XRCamera3D.transform.basis
	# We care only about the forward direction that we are looking at
	var forward : Vector2 = Vector2(camera_basis.z.x, camera_basis.z.z)
	# We retrieve the angle between the forward direction and what?
	var angle : float = forward.angle_to(Vector2(0.0, 1.0))
	# print(angle)
	
	# We rotate the character to the same angle that our camera rotated
	transform = transform.rotated(Vector3.UP, angle)

	# We rotate the XROrigin3D in the oposite direction, in order to keep it's correct position
	$XROrigin3D.transform = $XROrigin3D.transform.rotated(Vector3.UP, -angle)

