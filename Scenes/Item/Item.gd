extends Control
class_name Item

@export var item_data: ItemData

@onready var interactive_texture: InteractiveTexture = $InteractiveTexture

var shop_counter: ShopCounter

var draggable: bool = true
var mouse_click_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	shop_counter = get_tree().get_first_node_in_group('ShopCounter') as ShopCounter
	interactive_texture.update_texture(item_data.texture)


func setup(new_item_data: ItemData, p_draggable: bool = true) -> void:
	item_data = new_item_data
	draggable = p_draggable
	if not p_draggable:
		modulate.a = 0.5


func _has_point(point: Vector2) -> bool:
	var global_point: Vector2 = get_global_transform() * point
	var local_point: Vector2 = interactive_texture.get_global_transform().affine_inverse() * global_point
	
	return interactive_texture.is_pixel_interactive(local_point)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_drag()


#region Drag&Drop
func _start_drag() -> void:
	if not draggable:
		return
	
	PopoverManager.hide_popover()
	DragDropManager.drag_start([self])
#endregion Drag&Drop

#region Popover
func _show_popover() -> void:
	if DragDropManager.is_dragging:
		return
	
	PopoverManager.show_popover(
		PopoverManager.PopoverType.Item,
		item_data
	)


func _on_mouse_entered() -> void:
	_show_popover()


func _on_mouse_exited() -> void:
	PopoverManager.hide_popover()
#endregion Popover
