extends Control
class_name Customer

@onready var interactive_texture: InteractiveTexture = $InteractiveTexture
@onready var dialogue_marker_2d: DialogueMarker2D = $DialogueMarker2D

var dialogue_resource = load('res://Dialogues/buying.dialogue')

var can_start_dialog: bool = false
var customer_visit: CustomerVisit
var transaction_type: String = 'buy'

func _ready() -> void:
	interactive_texture.update_texture(customer_visit.customer_data.texture)
	dialogue_marker_2d.character_name = customer_visit.customer_data.name
	await walk_in()


func setup(data: CustomerVisit) -> void:
	customer_visit = data


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
	
	start_conversation('start')
	can_start_dialog = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_on_clicked(event.position)

var active_ballon: Node = null

func start_conversation(dialogue_name: String) -> void:
	if active_ballon:
		active_ballon.start(dialogue_resource, dialogue_name, [{
			"customer_name": customer_visit.customer_data.name
		}])
		return
	
	active_ballon = DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_name, [{
		"customer_name": customer_visit.customer_data.name
	}])


func approve_item() -> void:
	start_conversation('item_approved')
