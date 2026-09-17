class_name WaveSpawner
extends Node

signal wave_started(wave_number: int)

const ENEMY_SCENE := preload("res://entities/enemies/enemy_walker.tscn")
const WAVES := [
	{"count": 4, "speed": 60.0},
	{"count": 6, "speed": 65.0},
	{"count": 8, "speed": 70.0},
	{"count": 10, "speed": 75.0},
	{"count": 12, "speed": 80.0},
]

@export var wave_break_duration: float = 2.0
@export var spawn_margin: float = 20.0

var target: Node2D

var _wave_number: int = 0
var _break_remaining: float = 0.0


func _physics_process(delta: float) -> void:
	if get_child_count() > 0:
		return
	_break_remaining -= delta
	if _break_remaining > 0.0:
		return
	_start_next_wave()


func _start_next_wave() -> void:
	_wave_number += 1
	var wave: Dictionary = WAVES[mini(_wave_number, WAVES.size()) - 1]
	for i in wave["count"]:
		var enemy = ENEMY_SCENE.instantiate()
		enemy.move_speed = wave["speed"]
		enemy.target = target
		enemy.position = _random_edge_position()
		add_child(enemy)
	_break_remaining = wave_break_duration
	wave_started.emit(_wave_number)


func _random_edge_position() -> Vector2:
	var size := get_viewport().get_visible_rect().size
	match randi() % 4:
		0:
			return Vector2(randf() * size.x, -spawn_margin)
		1:
			return Vector2(randf() * size.x, size.y + spawn_margin)
		2:
			return Vector2(-spawn_margin, randf() * size.y)
		_:
			return Vector2(size.x + spawn_margin, randf() * size.y)
