extends Control
class_name Customer


const DIALOGUES = {
	CustomerVisit.VisitType.Buy: preload("uid://od3jb0o7uc68"),
	CustomerVisit.VisitType.Sell: preload("uid://d2q4ubv2cn7qj")
}


@onready var interactive_texture: InteractiveTexture = $InteractiveTexture
@onready var dialogue_marker_2d: DialogueMarker2D = $DialogueMarker2D


signal clicked


var customer_visit: CustomerVisit


func _ready() -> void:
	interactive_texture.update_texture(customer_visit.customer_data.texture)
	dialogue_marker_2d.character_name = customer_visit.customer_data.name


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				clicked.emit()


func _has_point(point: Vector2) -> bool:
	var global_point: Vector2 = get_global_transform() * point
	var local_point: Vector2 = interactive_texture.get_global_transform().affine_inverse() * global_point

	return interactive_texture.is_pixel_interactive(local_point)


func setup(data: CustomerVisit) -> void:
	customer_visit = data

#region Actions
func walk_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self,
		'position',
		position + Vector2(500, 0),
		3.0
	)
	
	await tween.finished


func walk_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		self,
		'position',
		position + Vector2(500, 0),
		3.0
	)
	
	await tween.finished
#endregion Actions


#region Dialogue
var active_ballon: Node = null

func start_conversation(dialogue_name: String) -> void:
	var dialogue_res: Resource = DIALOGUES[customer_visit.visit_type]
	
	if is_instance_valid(active_ballon):
		active_ballon.start(dialogue_res, dialogue_name, [{
			"customer_name": customer_visit.customer_data.name
		}])
		return
	
	active_ballon = DialogueManager.show_dialogue_balloon(dialogue_res, dialogue_name, [{
		"customer_name": customer_visit.customer_data.name
	}])
#endregion Dialogue
