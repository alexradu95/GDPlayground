extends Node3D

@export var mouse_sensitivity = 0.05

func _ready():
	# The node will not inherit its transformations from its parent.
	set_as_top_level(true)

# This is called everytime there is any kind input:
func _input(event):
	# There are many types of inputs, so we must specify what we listen to
	if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		# We clamp the rotation in order to not rotate too much on the x axis
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 10)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		# This will allow us to do a full 360 and more
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
