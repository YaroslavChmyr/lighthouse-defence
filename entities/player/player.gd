extends CharacterBody2D

@export var max_speed: float = 220.0
@export var acceleration: float = 1600.0
@export var friction: float = 1400.0
@export var half_extent: float = 12.0


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()
	_clamp_to_screen()


func _clamp_to_screen() -> void:
	var bounds := get_viewport_rect().size
	global_position.x = clampf(global_position.x, half_extent, bounds.x - half_extent)
	global_position.y = clampf(global_position.y, half_extent, bounds.y - half_extent)
