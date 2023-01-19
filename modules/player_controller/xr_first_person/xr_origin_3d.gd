extends XROrigin3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var playerbody_node = get_parent()
@onready var origin_node = self
@onready var camera_node = $XRCamera3D
@onready var head_position_node = $XRCamera3D/HeadPosition
@onready var blackout_node = $XRCamera3D/BlackOut

@export var eye_offset = 0.1:
	set(new_value):
		eye_offset = new_value
		if is_inside_tree():
			_update_head_position()

func _update_head_position():
	head_position_node.transform.origin.z = eye_offset
	if Engine.is_editor_hint():
		camera_node.transform.origin.z = -eye_offset

func _ready():
	_update_head_position()

func _process_on_physical_movement(delta) -> bool:
	# Remember the player body original velocity
	var org_velocity = playerbody_node.velocity

	# Start by rotating the player to face the same way our real player is
	var camera_basis : Basis = origin_node.transform.basis * camera_node.transform.basis
	var forward : Vector2 = Vector2(camera_basis.z.x, camera_basis.z.z)
	var angle : float = forward.angle_to(Vector2(0.0, 1.0))
	# print(angle)
	
	playerbody_node.transform.basis = playerbody_node.transform.basis.rotated(Vector3.UP, angle)
	origin_node.transform = Transform3D().rotated(Vector3.UP, -angle) * origin_node.transform

	# Now apply movement, first move our player body to the right location
	var org_player_body : Vector3 = playerbody_node.global_transform.origin
	var player_body_location : Vector3 = origin_node.transform * camera_node.transform * head_position_node.transform.origin
	player_body_location.y = 0.0
	player_body_location = global_transform * player_body_location

	playerbody_node.velocity = (player_body_location - org_player_body) / delta
	playerbody_node.move_and_slide()

	# Now move our XROrigin back
	var delta_movement = org_player_body - global_transform.origin
	delta_movement.y = 0.0
	origin_node.global_transform.origin += delta_movement

	# Return our value
	playerbody_node.velocity = org_velocity

	# Adjust our fade
	var distance : float = (player_body_location - org_player_body).length()
	var colliding = distance > 0.01
	if colliding:
		var material : ShaderMaterial = blackout_node.get_surface_override_material(0)
		if material:
			var fade : float = clamp(distance * 10.0, 0.0, 1.0)

			material.set_shader_parameter("fade", fade)
		blackout_node.visible = true
	else:
		blackout_node.visible = false

	return colliding

func _physics_process(delta):
	# Don't do this in editor
	if Engine.is_editor_hint():
		return

	var colliding = _process_on_physical_movement(delta)
