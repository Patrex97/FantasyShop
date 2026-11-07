extends TextureRect
class_name InteractiveTexture

signal clicked(click_pos: Vector2)
signal released

var alpha_threshold: float = 0.1

var image: Image


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP

	if texture:
		image = texture.get_image()


func update_texture(new_texture: Texture2D) -> void:
	texture = new_texture
	
	if texture:
		image = texture.get_image()

func _has_point(point: Vector2) -> bool:
	if image == null:
		return false

	if size.x <= 0 or size.y <= 0:
		return false

	var texture_size := Vector2(image.get_size())

	var uv := point / size
	var pixel_pos := Vector2i(uv * texture_size)

	if pixel_pos.x < 0 or pixel_pos.y < 0:
		return false

	if pixel_pos.x >= image.get_width() or pixel_pos.y >= image.get_height():
		return false

	return image.get_pixelv(pixel_pos).a > alpha_threshold


func _on_mouse_entered() -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("show_outline", true)


func _on_mouse_exited() -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("show_outline", false)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				clicked.emit(event.position)
			elif event.is_released():
				released.emit()
