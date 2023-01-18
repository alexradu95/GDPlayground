extends BaseCharacterBodyController

func _process(delta) :
	# We sync the SpringArm ( that contains the camera ) with the player position
	$SpringArm.position = position
	print(transform.origin)

func _physics_process(delta):
	handle_movement(delta)
	handle_rotation(delta)
	handle_jumping(delta)
	move_and_slide()
	
func handle_rotation(delta):
	# We sync the velocity direction with the direction of our spring arm, in order to move in the direction we are looking
	velocity = velocity.rotated(Vector3.UP, $SpringArm.rotation.y)
	# We sync the model rotation in order to also rotate the character in the direction we are moving
	$Model.rotation.y = $SpringArm.rotation.y

