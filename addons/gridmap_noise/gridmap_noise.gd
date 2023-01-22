@tool
extends GridMap

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 20

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
			var height : int = calculate_height_based_on_color(vector)
			vector.y = height
			set_cell_item(vector, height)
	
func calculate_height_based_on_color(positon: Vector3) -> float:
	# Height can be from -1 to +1
	var noise_color_height : float = noise.get_noise_2d(positon.x, positon.z)
	print("FOR POSITION: ")
	print(positon)
	print("WE HAVE THE HEIGHT:")
	print(noise_color_height)
	return noise_color_height * 10;
