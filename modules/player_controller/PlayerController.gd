extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	print(transform)

	move_and_slide()

func _inject_flat_fps():
	var fpsControllerResource : Resource = load("res://modules/player_controller/flat_first_person/1st_person_camera.tscn")
	var fpsCamera = fpsControllerResource.instantiate()
	self.add_child(fpsCamera)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _inject_flat_tps():
	var tpsControllerResource : Resource = load("res://modules/player_controller/flat_3rd_person/3rd_person_camera.tscn")
	var thirdPersonCamera = tpsControllerResource.instantiate()
	self.add_child(thirdPersonCamera)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _inject_xr_fps(mode):
	print(mode)
	var xrControllerResource = load("res://players/xr_first_person/XRController.tscn")
	return xrControllerResource.instantiate()


