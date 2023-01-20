extends Node

signal openXRAvailability

# Called when the node enters the scene tree for the first time.
func _ready():
	var xr_interface : OpenXRInterface = XRServer.find_interface('OpenXR')
	if xr_interface:
		openXRAvailability.emit(true)
	else:
		openXRAvailability.emit(false)
