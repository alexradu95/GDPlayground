@tool
extends BaseCharacterBodyController

@onready var origin_node = $XROrigin3D
@onready var camera_node = $XROrigin3D/XRCamera3D
@onready var blackout_node = $XROrigin3D/XRCamera3D/BlackOut

func _process_on_physical_movement(delta) -> bool:
	# Remember our velocity we're not applying that on physical movement
	var org_velocity = velocity

	_handle_camera_rotation()
	
	var distance_between_bodies : Vector3 = _calculate_distance_between_bodies()

	_move_virtual_player_body(distance_between_bodies, delta)

	_move_xr_origin_back_to_correct_possition()

	# Return our value
	velocity = org_velocity

	# Adjust our fade	
	var isColliding = _handle_fade_out(distance_between_bodies)

	return isColliding
	
func _calculate_distance_between_bodies() -> Vector3:
		# Now apply movement, first move our player body to the right location
	var virtual_player_body_global_location : Vector3 = global_transform.origin
	var real_player_body_global_location : Vector3 = _calculate_real_life_body_global_position_in_scene()
	return real_player_body_global_location - virtual_player_body_global_location
	
func _move_virtual_player_body(distance_between_bodies, delta) :

	velocity = distance_between_bodies / delta
	move_and_slide()
	
func _move_xr_origin_back_to_correct_possition():
	# Now move our XROrigin back
	var new_virtual_player_global_location : Vector3 = global_transform.origin
	var delta_movement = global_transform.origin - new_virtual_player_global_location
	delta_movement.y = 0.0
	$XROrigin3D.global_transform.origin += delta_movement
	
func _calculate_real_life_body_global_position_in_scene() -> Vector3:
	var real_life_player_body : Vector3 = origin_node.transform.origin * camera_node.transform.origin
	real_life_player_body.y = 0.0 # we negate the player height right now, hmm, ok?
	# maybe for this calculation
	real_life_player_body = global_transform * real_life_player_body
	
	return real_life_player_body
	
func _handle_camera_rotation():
	# Start by rotating the player to face the same way our real player is
	var camera_basis : Basis = origin_node.transform.basis * camera_node.transform.basis
	var forward : Vector2 = Vector2(camera_basis.z.x, camera_basis.z.z)
	var angle : float = forward.angle_to(Vector2(0.0, 1.0))
	# print(angle)
	
	transform.basis = transform.basis.rotated(Vector3.UP, angle)
	origin_node.transform = Transform3D().rotated(Vector3.UP, -angle) * origin_node.transform

func _handle_fade_out(distance) -> bool:
	return distance.length() > 0.01

func _process_on_player_input(delta):
	# Add the gravity.
	handle_jumping(delta)
	handle_movement(delta)
	move_and_slide()

func _physics_process(delta):
	# Don't do this in editor
	if Engine.is_editor_hint():
		return
	
	var player_is_out_of_bounds = _process_on_physical_movement(delta)
	if !player_is_out_of_bounds:
		_process_on_player_input(delta)
