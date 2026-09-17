extends Node2D

@onready var _player: Player = $Player
@onready var _wave_spawner: WaveSpawner = $WaveSpawner
@onready var _hud: Hud = $Hud
@onready var _game_over: GameOver = $GameOver


func _ready() -> void:
	_wave_spawner.target = _player
	_hud.set_health(_player.health)
	_player.health_changed.connect(_hud.set_health)
	_wave_spawner.wave_started.connect(_hud.set_wave)
	_player.died.connect(_on_player_died)
	_game_over.restart_requested.connect(_on_restart_requested)


func _on_player_died() -> void:
	_game_over.visible = true
	get_tree().paused = true


func _on_restart_requested() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
