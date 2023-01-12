extends XROrigin3D

func _init():
	print("XROrigin3D Activated | VRMode ON")

func _enter_tree():
	print(name + " VRMode has been added to the scene")

# Called when the node enters the scene tree for the first time.
func _ready():
	var xr_interface: XRInterface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		var vp : Viewport = get_viewport()
		vp.use_xr = true

