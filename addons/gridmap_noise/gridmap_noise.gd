@tool
extends GridMap


@export var noise: FastNoiseLite = FastNoiseLite.new()

@export var grid_size: int = 200 :
	set(value):
		grid_size = value
		generate_terrain_gridmap(grid_size)

@onready var increment = self.mesh_library.get_item_list().size();



func _ready():
	generate_terrain_gridmap(grid_size)
	
func generate_terrain_gridmap(size: int):
	clear()

	var treshholds = generate_thresholds()
	var i = 0
	
	var multiMeshInstance : MultiMeshInstance3D = $TreeMultiMesh
	$TreeMultiMesh.multimesh.instance_count = grid_size * 100
	
	for y in range(size):
		for x in range(size):
			var vector = Vector3(x, 0, y)
			var height : int = calculate_height_based_on_color(vector, treshholds)
			vector.y = height
						
			if $TreeMultiMesh:
				if i < $TreeMultiMesh.multimesh.instance_count && ( height == 5 || height == 6 || height == 7 ) && noise.get_noise_3dv(vector) > 0.15:
					$TreeMultiMesh.multimesh.set_instance_transform(i, Transform3D(Basis.IDENTITY, 
						vector + Vector3.RIGHT/2  + Vector3.BACK/2+ Vector3.UP))
					i = i+1
					$TreeMultiMesh.multimesh.visible_instance_count = i
					
			set_cell_item(vector, height)

func generate_thresholds() -> Array[float]:
	
	var meshLibrarySize : float = self.mesh_library.get_item_list().size()
	increment = 2 /  meshLibrarySize
	var thresholds : Array[float];
	
	for i in meshLibrarySize + 1:
		var value = -1 + i * increment
		thresholds.append(round_to_dec(value, 2))
	
	return thresholds
	
func calculate_height_based_on_color(positon: Vector3, treshholds: Array[float]) -> int:
	# Height can be from -1 to +1
	var eval : float = noise.get_noise_2d(positon.x, positon.z)
	var discreteValue = round_to_dec(eval, 2)
	for i in treshholds.size():
		if(discreteValue < treshholds[i]):
			return i
	return 0
	
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)


################################################ OLD METHOD ##############################

	
