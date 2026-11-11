extends TextureRect
class_name InteractiveTexture

var alpha_threshold: float = 0.1

var image: Image


func _ready() -> void:
	if texture:
		image = texture.get_image()
		size = texture.get_size()


func update_texture(new_texture: Texture2D) -> void:
	texture = new_texture
	
	if texture:
		image = texture.get_image()
		size = texture.get_size()

func is_pixel_interactive(point: Vector2) -> bool:
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
