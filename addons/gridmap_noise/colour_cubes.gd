@tool

extends Node3D

var color_array = [
	Color.LIGHT_BLUE, # Light Sky Blue
	Color.GREEN, # Forest Green
	Color.DARK_RED, # Dark Red
	Color.SALMON, # Light Salmon
	Color.GOLDENROD, # Dark Goldenrod
	Color.SADDLE_BROWN, # Saddle Brown
	Color.OLIVE_DRAB, # Olive Drab
	Color.DARK_GREEN, # Dark Green
	Color.GOLDENROD, # Goldenrod
	Color.GOLD, # Gold
	Color.YELLOW_GREEN, # Yellow Green
	Color.KHAKI, # Dark Khaki
	Color.SEA_GREEN, # Dark Sea Green
	Color.OLIVE, # Dark Olive Green
	Color.MAGENTA, # Dark Magenta
	Color.TEAL, # Teal
	Color.SLATE_GRAY, # Dark Slate Gray
	Color.INDIGO, # Indigo
	Color.RED, # Dark Red
	Color.MAROON # Maroon
]


# Called when the node enters the scene tree for the first time.
func _ready():
	var childCount = get_child_count()
	for i in childCount:
		var childCube : MeshInstance3D = get_child(i)
		var new_material = StandardMaterial3D.new()
		new_material.set_albedo(color_array[i])
		childCube.mesh.material = new_material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
