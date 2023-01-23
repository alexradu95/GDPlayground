@tool
extends GridMap

@onready var treeMultiMesh: MultiMeshInstance3D = $TreeMultiMesh

var increment = 0;

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 200

# When this button is pressed, the terrain will be generated again
@export var generate: bool = false :
	set(value):
			generate_terrain_gridmap(grid_size)
			generate = value
			
@export var clean: bool = false :
	set(value):
		cleanUp()
		clean = value
			

func _ready():
	generate_terrain_gridmap(grid_size)
	
func cleanUp():
	clear()
	treeMultiMesh.multimesh.instance_count = 0
	
func generate_terrain_gridmap(size: int):
	clear()
	
	treeMultiMesh.multimesh.instance_count = grid_size * grid_size
	
	var waterBox = BoxMesh.new()
	waterBox.size = Vector3(size+1, 3, size+1)

	var treshholds = generate_thresholds()
	var i = 0
	
	for y in range(size):
		for x in range(size):
			var vector = Vector3(x, 0, y)
			var height : int = calculate_height_based_on_color(vector, treshholds)
			vector.y = height
			
			if treeMultiMesh:
				if i < treeMultiMesh.multimesh.instance_count && ( height == 7 ||  height == 8 ) && noise.get_noise_3dv(vector) > 0.1:
					treeMultiMesh.multimesh.set_instance_transform(i, Transform3D(Basis.IDENTITY, 
						vector + Vector3.RIGHT/2  + Vector3.BACK/2+ Vector3.UP))
					i = i+1
			
			set_cell_item(vector, height)
			
	if treeMultiMesh:
		treeMultiMesh.multimesh.visible_instance_count = i
			
func generate_thresholds() -> Array[float]:
	
	var meshLibrarySize : float = self.mesh_library.get_item_list().size()
	increment = 2 /  meshLibrarySize
	var thresholds : Array[float];
	
	for i in meshLibrarySize:
		var value = -1 + i * increment
		thresholds.append(round_to_dec(value, 2))
	
	return thresholds
	
func calculate_height_based_on_color(positon: Vector3, treshholds: Array[float]) -> int:
	# Height can be from -1 to +1
	var eval : float = noise.get_noise_2d(positon.x, positon.z)
	var discreteValue = round_to_dec(eval, 2)
	for i in treshholds.size():
		var valueToTest = -1 + i * increment
		if(valueToTest > discreteValue):
			return i
	return 0
	
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
