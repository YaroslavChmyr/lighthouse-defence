extends CharacterBody2D

@export var max_health: int = 3

var health: int


func _ready() -> void:
	health = max_health
	add_to_group("enemies")


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()
