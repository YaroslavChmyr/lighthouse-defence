class_name Hud
extends CanvasLayer

@onready var _health_label: Label = $HealthLabel


func set_health(health: int) -> void:
	_health_label.text = "HP: %d" % health
