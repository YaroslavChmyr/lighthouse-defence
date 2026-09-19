class_name EnemyWalker
extends CharacterBody2D

const GROUP := &"enemies"

@export var max_health: int = 3
@export var move_speed: float = 60.0

var health: int
var target: Node2D


func _ready() -> void:
	health = max_health
	add_to_group(GROUP)


func _physics_process(_delta: float) -> void:
	velocity = global_position.direction_to(target.global_position) * move_speed
	move_and_slide()


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
