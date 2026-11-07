extends Control
class_name Item

@export var item_data: ItemData

@onready var interactive_texture: InteractiveTexture = $InteractiveTexture


var is_dragging: bool = false
var mouse_click_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	interactive_texture.update_texture(item_data.texture)
	
	interactive_texture.clicked.connect(_drag_start)
	interactive_texture.released.connect(_drop)


func setup(new_item_data: ItemData) -> void:
	item_data = new_item_data

func _process(_delta: float) -> void:
	if is_dragging:
		_drag()


#region Drag&Drop
func _drag_start(clicked_pos: Vector2) -> void:
	is_dragging = true
	mouse_click_offset = clicked_pos


func _drag() -> void:
		interactive_texture.global_position = get_global_mouse_position() - mouse_click_offset


func _drop() -> void:
	is_dragging = false
#endregion Drag&Drop

#region Popover
func _on_interactive_texture_mouse_entered() -> void:
	PopoverManager.show_popover(PopoverManager.PopoverType.Item, item_data)


func _on_interactive_texture_mouse_exited() -> void:
	PopoverManager.hide_popover()
#endregion Popover
