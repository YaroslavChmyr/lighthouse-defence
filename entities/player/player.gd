class_name Player
extends CharacterBody2D

signal health_changed(health: int)
signal died

@export var max_speed: float = 220.0
@export var acceleration: float = 1600.0
@export var friction: float = 1400.0
@export var half_extent: float = 12.0
@export var max_health: int = 3
@export var invulnerability_duration: float = 1.0
@export var flash_interval: float = 0.1
@export var movement_speed_step: float = 40.0
@export var shield_recharge_duration: float = 6.0

var health: int

var _invulnerable_remaining: float = 0.0
var _has_shield: bool = false
var _is_shield_charged: bool = false
var _shield_recharge_remaining: float = 0.0

@onready var _beam: Beam = $Beam
@onready var _body_rect: ColorRect = $ColorRect
@onready var _shield_rect: ColorRect = $ShieldRect
@onready var _hurtbox: Area2D = $Hurtbox


func _ready() -> void:
	health = max_health


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
	_clamp_to_screen()
	_update_shield(delta)
	_update_contact_damage(delta)


func _process(_delta: float) -> void:
	if _invulnerable_remaining > 0.0:
		_body_rect.visible = fmod(_invulnerable_remaining, flash_interval * 2.0) < flash_interval
	else:
		_body_rect.visible = true


func apply_upgrade(id: StringName) -> void:
	match id:
		&"faster_sweep":
			_beam.sweep_speed += _beam.sweep_speed_step
		&"wider_beam":
			_beam.beam_half_width += _beam.half_width_step
		&"second_beam":
			_beam.add_second_beam()
		&"movement_speed":
			max_speed += movement_speed_step
		&"shield":
			_has_shield = true
			_set_shield_charged(true)


func _clamp_to_screen() -> void:
	var bounds := get_viewport_rect().size
	global_position.x = clampf(global_position.x, half_extent, bounds.x - half_extent)
	global_position.y = clampf(global_position.y, half_extent, bounds.y - half_extent)


func _update_shield(delta: float) -> void:
	if not _has_shield or _is_shield_charged:
		return
	_shield_recharge_remaining -= delta
	if _shield_recharge_remaining <= 0.0:
		_set_shield_charged(true)


func _set_shield_charged(charged: bool) -> void:
	_is_shield_charged = charged
	_shield_rect.visible = charged


func _update_contact_damage(delta: float) -> void:
	if _invulnerable_remaining > 0.0:
		_invulnerable_remaining -= delta
		return
	if _hurtbox.has_overlapping_bodies():
		_take_hit()


func _take_hit() -> void:
	_invulnerable_remaining = invulnerability_duration

	if _is_shield_charged:
		_set_shield_charged(false)
		_shield_recharge_remaining = shield_recharge_duration
		return

	health -= 1
	health_changed.emit(health)
	if health <= 0:
		_invulnerable_remaining = 0.0
		died.emit()
