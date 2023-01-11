extends CharacterBody3D

@export var speed = 10
@export var jump_velocity = 20
@export var look_sensitivity = 0.05

# We need the Camera3D to apply the UP/Down Rotation from mouse
@onready var camera:Camera3D = $Camera3D

# The gravity will affect the jump functionality
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Y is the UP Vector in Godot, we will use this to implement jumping
var velocity_y = 0


func _physics_process(delta):
	handle_movement(delta)
	toggle_mouse_capture()
	
func toggle_mouse_capture():
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE


func handle_movement(delta):
	# We build a Vector2 from the Keyboard Inputs
	# We normalize it in order for it to not add when we are moving diagonally
	# We multiply it be the speed
	var horizontal_velocity = Input.get_vector("move_left","move_right","move_forward","move_backward").normalized() * speed
	# We apply the horizontal_velocity to our Node velocity
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z

	handle_jumping(delta)
	move_and_slide()
	
func handle_jumping(delta) :
	if is_on_floor():
		velocity_y = 0
		if Input.is_action_just_pressed("jump") :
			velocity_y = jump_velocity
	else: 
		velocity_y -= gravity * delta
	velocity.y = velocity_y

# This is called everytime there is any kind input:
func _input(event):
	# There are many types of inputs, so we must specify what we listen to
	if event is InputEventMouseMotion:
		# We rotate the Node on it's Y axis
		rotate_y(-event.relative.x * look_sensitivity)
		# We rotate the Camera on X axis in order to not mess with the controls
		camera.rotate_x(-event.relative.y * look_sensitivity)
		# We clamp the rotation in order to not rotate indifently on vertical axis
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
