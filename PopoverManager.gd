extends CanvasLayer

enum PopoverType {
	Item
}

const POPOVERS = {
	PopoverType.Item: preload("uid://bescp2gu4y8fj")
}


var current_popover: Control = null

var current_mouse_position: Vector2 = Vector2.ZERO


func _input(event: InputEvent) -> void:
	if not current_popover:
		return

	if event is InputEventMouseMotion:
		current_mouse_position = event.position
		current_popover.global_position = (
			event.position + Vector2(15, 15)
		)

func show_popover(popover_type: PopoverType, data: Variant) -> void:
	hide_popover()
	
	current_popover = POPOVERS[popover_type].instantiate()
	
	current_popover.setup(data)
	
	add_child(current_popover)

func hide_popover() -> void:
	if not current_popover:
		return
	
	current_popover.queue_free()
	current_popover = null
