extends Control
class_name Item

@export var item_data: ItemData

@onready var interactive_texture: InteractiveTexture = $InteractiveTexture


var is_dragging: bool = false
var mouse_click_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	interactive_texture.update_texture(item_data.texture)


func setup(new_item_data: ItemData) -> void:
	item_data = new_item_data


func _has_point(point: Vector2) -> bool:
	var global_point: Vector2 = get_global_transform() * point
	var local_point: Vector2 = interactive_texture.get_global_transform().affine_inverse() * global_point

	return interactive_texture.is_pixel_interactive(local_point)


func _process(_delta: float) -> void:
	if is_dragging:
		_drag()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_start_drag(event.position)
			else:
				_drop()

#region Drag&Drop
func _start_drag(clicked_pos: Vector2) -> void:
	is_dragging = true
	mouse_click_offset = clicked_pos
	
	PopoverManager.hide_popover()


func _drag() -> void:
	global_position = get_global_mouse_position() - mouse_click_offset


func _drop() -> void:
	is_dragging = false
	
	_show_popover()
#endregion Drag&Drop

#region Popover
func _show_popover() -> void:
	PopoverManager.show_popover(PopoverManager.PopoverType.Item, item_data)


func _on_mouse_entered() -> void:
	_show_popover()


func _on_mouse_exited() -> void:
	PopoverManager.hide_popover()
#endregion Popover
