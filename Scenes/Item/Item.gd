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


func _process(_delta: float) -> void:
	if not is_dragging:
		return
	
	_drag()



func _drag_start(clicked_pos: Vector2) -> void:
	is_dragging = true
	mouse_click_offset = clicked_pos
	print('Drag start')


func _drag() -> void:
		interactive_texture.global_position = get_global_mouse_position() - mouse_click_offset


func _drop() -> void:
	is_dragging = false
	print('Drop')
