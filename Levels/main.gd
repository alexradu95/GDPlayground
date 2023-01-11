extends Node3D

@export var use_passthrough : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		var vp : Viewport = get_viewport()
		vp.transparent_bg = true
		vp.use_xr = use_passthrough
		xr_interface.start_passthrough()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
