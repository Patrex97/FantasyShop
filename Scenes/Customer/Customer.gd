extends Control
class_name Customer


@onready var interactive_texture: InteractiveTexture = $InteractiveTexture

func _ready() -> void:
	interactive_texture.clicked.connect(_on_texture_clicked)
	await walk_in()

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
	
	queue_free()


func _on_texture_clicked() -> void:
	DialogueManager.show_dialogue_balloon(load('res://Dialogues/buying.dialogue'), 'start')
