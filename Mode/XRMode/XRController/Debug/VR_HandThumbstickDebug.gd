extends Label3D

var controller: XRController3D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.controller = self.get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = controller.get_axis("primary").normalized()
	var x = "%.2f" % movement_vector.x
	var y = "%.2f" % movement_vector.y
	# Define a format string with placeholder '%s'
	var format_string = "%s %s"
	# Using the '%' operator, the placeholder is replaced with the desired value
	var actual_string = format_string % [x, y]	
	self.set_text(actual_string)