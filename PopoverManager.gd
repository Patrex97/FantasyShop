extends CanvasLayer

enum PopoverType {
	Item
}

const POPOVERS = {
	PopoverType.Item: preload("uid://bescp2gu4y8fj")
}

const POPOVER_OFFSET = Vector2(15, 15)

var current_popover: Control = null
var current_mouse_position: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		return
	
	current_mouse_position = event.global_position
	
	_update_popover_position()

func _update_popover_position() -> void:
	if not current_popover:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var popover_size = current_popover.size
	
	var position = current_mouse_position + POPOVER_OFFSET
	
	# Brak miejsca po prawej stronie
	if position.x + popover_size.x > viewport_size.x:
		position.x = current_mouse_position.x - popover_size.x - POPOVER_OFFSET.x
	
	# Brak miejsca na dole
	if position.y + popover_size.y > viewport_size.y:
		position.y = current_mouse_position.y - popover_size.y

	# Zabezpieczenie przed wyjściem poza ekran
	position.x = clampf(position.x, 0.0, maxf(0.0, viewport_size.x - popover_size.x))
	position.y = clampf(position.y, 0.0, maxf(0.0, viewport_size.y - popover_size.y))

	current_popover.position = position

func show_popover(popover_type: PopoverType, data: Variant) -> void:
	hide_popover()
	
	current_popover = POPOVERS[popover_type].instantiate()
	
	current_popover.setup(data)
	add_child(current_popover)
	
	await get_tree().process_frame
	
	_update_popover_position()

func hide_popover() -> void:
	if not current_popover:
		return
	
	current_popover.queue_free()
	current_popover = null
