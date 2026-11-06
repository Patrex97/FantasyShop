extends Control

@onready var dialog_anchor: Marker2D = $DialogAnchor

var DIALOGS = [
	{
		"type": "Text",
		"speaker": "customer",
		"value": "Witaj. Szukam dobrego miecza."
	}, 
	{ 
		"type": "Action",
		"anchor": "player",
		"options": [
			{
				"key": "offer",
				"label": "Mam dla ciebie miecz",
			},
			{
				"key": "decline",
				"label": "Niestety nie mam dla ciebie miecza"
			}
		],
	}
]

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	DialogueManager.show_dialogue_balloon(load("res://Dialogues/buying.dialogue"), "start")
