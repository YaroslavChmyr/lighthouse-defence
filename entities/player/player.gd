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

var health: int

var _invulnerable_remaining: float = 0.0

@onready var _body_rect: ColorRect = $ColorRect
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
	_update_contact_damage(delta)


func _process(_delta: float) -> void:
	if _invulnerable_remaining > 0.0:
		_body_rect.visible = fmod(_invulnerable_remaining, flash_interval * 2.0) < flash_interval
	else:
		_body_rect.visible = true


func _clamp_to_screen() -> void:
	var bounds := get_viewport_rect().size
	global_position.x = clampf(global_position.x, half_extent, bounds.x - half_extent)
	global_position.y = clampf(global_position.y, half_extent, bounds.y - half_extent)


func _update_contact_damage(delta: float) -> void:
	if _invulnerable_remaining > 0.0:
		_invulnerable_remaining -= delta
		return
	if _hurtbox.has_overlapping_bodies():
		_take_hit()


func _take_hit() -> void:
	health -= 1
	health_changed.emit(health)
	if health <= 0:
		died.emit()
		return
	_invulnerable_remaining = invulnerability_duration
