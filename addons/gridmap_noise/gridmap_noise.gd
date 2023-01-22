@tool
extends GridMap

var surfaceTool : SurfaceTool = SurfaceTool.new() 

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 20
@export var rimSize: int = 4 

# When this button is pressed, the terrain will be generated again
@export var generate: bool = false :
	set(value):
		generate_terrain_gridmap(grid_size)
		generate = value

func _ready():
	generate_terrain_gridmap(grid_size)
	
func generate_terrain_gridmap(size: int):
	clear()

	for y in range(size):
		for x in range(size):
			var vector = Vector3(x, 0, y)
			var height = calculate_height_based_on_color(vector)
			vector.y = height
			set_cell_item(vector, height)
	
func calculate_height_based_on_color(positon: Vector3) -> int:
	# Height can be from -1 to +1
	var noise_color_height : float = noise.get_noise_2d(positon.x, positon.z)
	var grid_map_height : float = 1
	
	if noise_color_height >= 0.9:
		return 9
	if noise_color_height >= 0.8:
		return 8
	if noise_color_height >= 0.7:
		return 7
	if noise_color_height >= 0.6:
		return 6
	if noise_color_height >= 0.5:
		return 5
	if noise_color_height >= 0.4:
		return 4
	if noise_color_height >= 0.3:
		return 3
	elif noise_color_height >= 0.2:
		return 2
	elif noise_color_height >= 0.0:
		return 1
	elif noise_color_height <= -0.2:
		return 0
		
	return 1
