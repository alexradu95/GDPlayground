class_name XrOrFlatModeLauncher
extends Node

signal launch_xr
signal launch_fps
signal launch_tps
##
## XR / Flat Mode Game Launcher
##
## The script launches the game in either flat or xr modes
##

# Launch the XR scene
func launch_xr_button_pressed():
	emit_signal("launch_xr")
	#self.hide()

# Launch the Flat Scene
func launch_fps_button_pressed():
	emit_signal("launch_fps")
	#self.hide()
	
func launch_tps_button_pressed():
	emit_signal("launch_tps")
	#self.hide()
