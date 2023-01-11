class_name XrOrFlatModeLauncher
extends Node

##
## XR / Flat Mode Game Launcher
##
## The script launches the game in either flat or xr modes
##

# Launch the XR scene
func launch_xr():
	emit_signal("launch_xr")
	self.hide()

# Launch the Flat Scene
func launch_flat():
	emit_signal("launch_fps")
	self.hide()
