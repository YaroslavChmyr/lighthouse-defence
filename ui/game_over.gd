class_name GameOver
extends CanvasLayer

signal restart_requested


func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_accept"):
		restart_requested.emit()
