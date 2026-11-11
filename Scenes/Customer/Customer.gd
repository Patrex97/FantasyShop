extends Control
class_name Customer


@onready var interactive_texture: InteractiveTexture = $InteractiveTexture


var can_start_dialog: bool = false
var customer_data: CustomerData


func _ready() -> void:
	print(customer_data)
	interactive_texture.update_texture(customer_data.texture)
	await walk_in()


func setup(data: CustomerData) -> void:
	customer_data = data


func _has_point(point: Vector2) -> bool:
	var global_point: Vector2 = get_global_transform() * point
	var local_point: Vector2 = interactive_texture.get_global_transform().affine_inverse() * global_point

	return interactive_texture.is_pixel_interactive(local_point)


func walk_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self,
		'position',
		position + Vector2(500, 0),
		3.0
	)
	
	await tween.finished
	can_start_dialog = true


func walk_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self,
		'position',
		position + Vector2(500, 0),
		3.0
	)
	
	await tween.finished
	
	queue_free()


func _on_clicked(_clicked_pos: Vector2) -> void:
	if not can_start_dialog:
		return
	
	DialogueManager.show_dialogue_balloon(load('res://Dialogues/buying.dialogue'), 'start')
	can_start_dialog = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_on_clicked(event.position)
