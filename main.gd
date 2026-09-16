extends Node2D

@onready var _player: Player = $Player
@onready var _hud: Hud = $Hud
@onready var _game_over: GameOver = $GameOver


func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.target = _player
	_hud.set_health(_player.health)
	_player.health_changed.connect(_hud.set_health)
	_player.died.connect(_on_player_died)
	_game_over.restart_requested.connect(_on_restart_requested)


func _on_player_died() -> void:
	_game_over.visible = true
	get_tree().paused = true


func _on_restart_requested() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
