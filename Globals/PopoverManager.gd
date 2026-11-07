extends Node

enum PopoverType {
	Item
}

const POPOVERS = {
	PopoverType.Item: preload("uid://bescp2gu4y8fj")
}


var current_popover: Control = null


func _process(_delta: float) -> void:
	if not current_popover:
		return
	
	current_popover.global_position = (
		current_popover.get_global_mouse_position()
		+ Vector2(15, 15)
	)

func show_popover(popover_type: PopoverType, data: Variant) -> void:
	hide_popover()
	
	current_popover = POPOVERS[popover_type].instantiate()
	
	current_popover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	current_popover.setup(data)
	
	PopoverManager.add_child(current_popover)

func hide_popover() -> void:
	if not current_popover:
		return
	
	current_popover.queue_free()
	current_popover = null
