class_name Beam
extends Node2D

const ARC_SEGMENTS := 16

@export_range(0.0, 720.0, 1.0, "radians_as_degrees") var sweep_speed: float = deg_to_rad(90.0)
@export_range(0.0, 360.0, 1.0, "radians_as_degrees") var sweep_speed_step: float = deg_to_rad(30.0)
@export_range(0.5, 90.0, 0.5, "radians_as_degrees") var beam_half_width: float = deg_to_rad(12.0)
@export_range(0.5, 45.0, 0.5, "radians_as_degrees") var half_width_step: float = deg_to_rad(6.0)
@export_range(1.0, 1500.0, 1.0) var beam_range: float = 400.0
@export var beam_damage: int = 1
@export_range(0.0, 2.0, 0.01) var hit_cooldown: float = 0.3
@export var beam_color: Color = Color(1.0, 0.9, 0.4, 0.35)

var beam_angle: float = 0.0

var _angle_offsets: Array[float] = [0.0]
var _hit_cooldowns: Dictionary = {}


func add_second_beam() -> void:
	_angle_offsets = [0.0, PI]


func _physics_process(delta: float) -> void:
	_tick_hit_cooldowns(delta)
	beam_angle = fposmod(beam_angle + sweep_speed * delta, TAU)
	_hit_enemies_in_beam()


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	for offset in _angle_offsets:
		draw_colored_polygon(_wedge_points(beam_angle + offset), beam_color)


func _wedge_points(center_angle: float) -> PackedVector2Array:
	var points := PackedVector2Array([Vector2.ZERO])
	var start_angle := center_angle - beam_half_width
	var step := beam_half_width * 2.0 / ARC_SEGMENTS
	for i in ARC_SEGMENTS + 1:
		points.append(Vector2.from_angle(start_angle + step * i) * beam_range)
	return points


func _tick_hit_cooldowns(delta: float) -> void:
	for id in _hit_cooldowns.keys():
		_hit_cooldowns[id] -= delta
		if _hit_cooldowns[id] <= 0.0:
			_hit_cooldowns.erase(id)


func _is_in_any_beam(to_enemy: Vector2) -> bool:
	var enemy_angle := to_enemy.angle()
	for offset in _angle_offsets:
		if absf(angle_difference(beam_angle + offset, enemy_angle)) <= beam_half_width:
			return true
	return false


func _hit_enemies_in_beam() -> void:
	for enemy in get_tree().get_nodes_in_group(EnemyWalker.GROUP):
		var id := enemy.get_instance_id()
		if _hit_cooldowns.has(id):
			continue
		var to_enemy: Vector2 = enemy.global_position - global_position
		if to_enemy.length() > beam_range:
			continue
		if not _is_in_any_beam(to_enemy):
			continue
		enemy.take_damage(beam_damage)
		_hit_cooldowns[id] = hit_cooldown
