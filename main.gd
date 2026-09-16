extends Node2D

@onready var _player: Node2D = $Player


func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.target = _player
