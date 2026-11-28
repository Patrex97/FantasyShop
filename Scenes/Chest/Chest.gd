extends PanelContainer
class_name Chest


var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_start_drag()
			accept_event()


func _input(event: InputEvent) -> void:
	if not is_dragging:
		return

	if event is InputEventMouseMotion:
		_update_drag()

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_end_drag()


func _start_drag() -> void:
	is_dragging = true
	drag_offset = get_global_mouse_position() - global_position
	move_to_front()


func _update_drag() -> void:
	var target_position: Vector2 = get_global_mouse_position() - drag_offset
	var viewport_size: Vector2 = get_viewport_rect().size
	var max_position: Vector2 = (viewport_size - size).max(Vector2.ZERO)

	global_position = target_position.clamp(Vector2.ZERO, max_position)


func _end_drag() -> void:
	is_dragging = false
