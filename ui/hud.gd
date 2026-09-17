class_name Hud
extends CanvasLayer

@onready var _health_label: Label = $HealthLabel
@onready var _wave_label: Label = $WaveLabel


func set_health(health: int) -> void:
	_health_label.text = "HP: %d" % health


func set_wave(wave_number: int) -> void:
	_wave_label.text = "Wave: %d" % wave_number
