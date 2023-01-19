extends XROrigin3D

@onready var player_node = get_parent()
@onready var origin_node : XROrigin3D = self
@onready var camera_node = $XRCamera3D
@onready var head_position_node = $XRCamera3D/HeadPosition

@export var eye_offset = 0.1:
	set(new_value):
		eye_offset = new_value
		if is_inside_tree():
			_update_head_position()


func _update_head_position():
	head_position_node.transform.origin.z = eye_offset

func _ready():
	_update_head_position()

func _process_on_physical_movement(delta):
	# Remember our velocity we're not applying that on physical movement
	var org_velocity = player_node.velocity

	# Start by rotating the player to face the same way our real player is
	var camera_basis : Basis = origin_node.transform.basis * camera_node.transform.basis
	var forward : Vector2 = Vector2(camera_basis.z.x, camera_basis.z.z)
	var angle : float = forward.angle_to(Vector2(0.0, 1.0))
	# print(angle)
	
	player_node.transform.basis = player_node.transform.basis.rotated(Vector3.UP, angle)
	origin_node.transform = Transform3D().rotated(Vector3.UP, -angle) * origin_node.transform

	# Now apply movement, first move our player body to the right location
	var virtual_player_body_global : Vector3 = player_node.global_transform.origin
	var real_player_body_global : Vector3 = origin_node.transform * camera_node.transform * head_position_node.transform.origin
	real_player_body_global.y = 0.0
	real_player_body_global = player_node.global_transform * real_player_body_global

	player_node.velocity = (real_player_body_global - virtual_player_body_global) / delta
	get_parent().move_and_slide()

	# Now move our XROrigin back
	var delta_movement = virtual_player_body_global - player_node.global_transform.origin
	delta_movement.y = 0.0
	origin_node.global_transform.origin += delta_movement

	# Return our value
	player_node.velocity = org_velocity

	# Adjust our fade
	var distance : float = (real_player_body_global - virtual_player_body_global).length()
	var colliding = distance > 1
	if(distance > 1):
		# Reset the player origin to PlayerBody
		camera_node.transform.origin = Vector3.ZERO
	elif(distance > 0.2):
		print("GO BACK TO YOUR REAL BODY, OR ELSE WE WILL FORCE MOVE YOU")

func _physics_process(delta):
	_process_on_physical_movement(delta)
