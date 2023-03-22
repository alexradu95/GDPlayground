extends Node3D

var interface: XRInterface

func _ready():
		interface = XRServer.find_interface("OpenXR")
		if interface and interface.is_initialized():
				print("OpenXR initialised successfully")

				get_viewport().use_xr = true
		else:
				print("OpenXR not initialised, please check if your headset is connected")


func enable_passthrough() -> bool:
	var xr_interface: XRInterface = XRServer.primary_interface
	if xr_interface and xr_interface.is_passthrough_supported():
		return xr_interface.start_passthrough()
	else:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.set_environment_blend_mode(XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND)
			return true
		else:
			return false
