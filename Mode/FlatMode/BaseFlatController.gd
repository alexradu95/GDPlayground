extends CharacterBody3D
class_name BaseCharacterBodyController

@export var move_speed = 5
@export var jump_velocity = 5
@export var mouse_sensitivity = 0.03

# The gravity will affect the jump functionality
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Y is the UP Vector in Godot, we will use this to implement jumping
var velocity_y = 0
var horizontal_velocity = Vector2.ZERO

func handle_movement(delta):
	# We build a Vector2 from the Keyboard Inputs
	# We normalize it in order for it to not add when we are moving diagonally
	# We multiply it be the speed
	horizontal_velocity = Input.get_vector("move_left","move_right","move_forward","move_backward").normalized() * move_speed
	# We apply the horizontal_velocity to our Node velocity
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z	

func handle_jumping(delta) :
	if is_on_floor():
		velocity_y = 0
		if Input.is_action_just_pressed("jump") :
			velocity_y = jump_velocity
	else: 
		velocity_y -= gravity * delta
	velocity.y = velocity_y
	
func toggle_mouse_capture():
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
