extends Control

@onready var _label: Label = $Label
var _player;

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_pos: Vector3 = _player.global_transform.origin
	_label.text = "Player position: (%.2f, %.2f, %.2f)" % [player_pos.x, player_pos.y, player_pos.z]
