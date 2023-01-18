extends Node

enum WebXRPrimary {
	AUTO,
	THUMBSTICK,
	TRACKPAD,
}

const WebXRPrimaryName := {
	WebXRPrimary.AUTO: "auto",
	WebXRPrimary.THUMBSTICK: "thumbstick",
	WebXRPrimary.TRACKPAD: "trackpad",
}

## User setting for snap-turn
@export var snap_turning : bool = true

## User setting for player height adjust
@export var player_height_adjust : float = 0.0: set = set_player_height_adjust




# Called when the node enters the scene tree for the first time.
func _ready():
	var webxr_interface = XRServer.find_interface("WebXR")
	if webxr_interface:
		

	_load()


## Reset to default values
func reset_to_defaults() -> void:
	# Reset to defaults
	player_height_adjust = 0.0
	webxr_primary = WebXRPrimary.AUTO
	webxr_auto_primary = 0


## Set the player height adjust property
func set_player_height_adjust(new_value : float) -> void:
	player_height_adjust = clamp(new_value, -1.0, 1.0)




## Save the settings to file
func save() -> void:
	# Construct the settings dictionary
	var data = {
		"input" : {
			"default_snap_turning" : snap_turning,
		},
		"player" : {
			"height_adjust" : player_height_adjust
		},
		"webxr" : {
			"webxr_primary" : webxr_primary,
		}
	}

	# Save to file
	var file := FileAccess.open(settings_file_name, FileAccess.WRITE)
	if file:
		file.store_line(JSON.stringify(data))



