class_name UpgradeScreen
extends CanvasLayer

signal upgrade_chosen(upgrade: Dictionary)

const SELECTED_MODULATE := Color(1.0, 1.0, 1.0, 1.0)
const UNSELECTED_MODULATE := Color(1.0, 1.0, 1.0, 0.4)

var _offer: Array = []
var _selected_index: int = 0

@onready var _slots: Array = $Layout/Options.get_children()


func show_offer(offer: Array) -> void:
	assert(offer.size() == _slots.size(), "Offer size must match the number of slots in the scene")
	_offer = offer
	for i in _slots.size():
		var upgrade: Dictionary = offer[i]
		_slots[i].get_node("Label").text = "%s\n\n%s" % [upgrade["name"], upgrade["description"]]
	_select(0)
	visible = true


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("move_left"):
		_select(wrapi(_selected_index - 1, 0, _slots.size()))
	elif event.is_action_pressed("move_right"):
		_select(wrapi(_selected_index + 1, 0, _slots.size()))
	elif event.is_action_pressed("ui_accept"):
		visible = false
		upgrade_chosen.emit(_offer[_selected_index])


func _select(index: int) -> void:
	_selected_index = index
	for i in _slots.size():
		_slots[i].modulate = SELECTED_MODULATE if i == index else UNSELECTED_MODULATE
