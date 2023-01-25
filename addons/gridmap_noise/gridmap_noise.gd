@tool
extends Node3D

@onready var waterMesh: MeshInstance3D = $Water
@onready var treeMultiMesh: MultiMeshInstance3D = $TreeMultiMesh
@onready var gridMap: GridMap = $GridMap


@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var size: int = 200
@export var marginSize: int = 4 

var instancedTrees = 0

@export var generate: bool = false :
	set(value):
		if Engine.is_editor_hint():
			generate_terrain_gridmap(size)
			generate = value
		
@export var clean: bool = false :
	set(value):
		if Engine.is_editor_hint():
			cleanUp()
			clean = value
		
func cleanUp():
	gridMap.clear()
	treeMultiMesh.multimesh.instance_count = 0

func _ready():
	generate_terrain_gridmap(size)

func generate_terrain_gridmap(size: int):
	cleanUp()
	
	treeMultiMesh.multimesh.instance_count = size * size
	
	if(waterMesh):
		waterMesh.mesh.size = Vector3(size+1, 3, size+1)
	
	var treshholds = generate_thresholds()

	
	for y in range(size):
		for x in range(size):
			var vector = Vector3(x, 0, y)
			var eval = self.evaluate(vector, treshholds)
			
			if y <= marginSize-1 || x <= marginSize-1 || y >= size-marginSize || x >= size-marginSize :
				eval = 1
				self.gridMap.set_cell_item(vector + Vector3.UP, -1)
				self.gridMap.set_cell_item(vector + 2 * Vector3.UP, -1)
				self.gridMap.set_cell_item(vector + 3 * Vector3.UP, -1)
			
			vector.y = eval

			if treeMultiMesh:
				if instancedTrees < treeMultiMesh.multimesh.instance_count && eval == $GridMap.mesh_library.get_item_list().size() / 2 && noise.get_noise_3dv(vector) > 0.15:
					treeMultiMesh.multimesh.set_instance_transform(instancedTrees, Transform3D(Basis.IDENTITY, 
						vector + Vector3.RIGHT/2  + Vector3.BACK/2+ Vector3.UP))
					instancedTrees += 1
					
			self.gridMap.set_cell_item(vector, eval)
	
	#if treeMultiMesh:
	#	treeMultiMesh.multimesh.visible_instance_count = instancedTrees
	
func evaluate(positon: Vector3, treshholds: Array[float]) -> int:
	# Height can be from -1 to +1
	var eval : float = noise.get_noise_2d(positon.x, positon.z)
	var discreteValue = round_to_dec(eval, 2)
	for i in treshholds.size():
		if(discreteValue < treshholds[i]):
			return i
	return 0

func generate_thresholds() -> Array[float]:
	
	var meshLibrarySize : float = $GridMap.mesh_library.get_item_list().size()
	var increment = 2 /  meshLibrarySize
	var thresholds : Array[float];
	
	for i in meshLibrarySize + 1:
		var value = -1 + i * increment
		thresholds.append(round_to_dec(value, 2))
	
	return thresholds

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
