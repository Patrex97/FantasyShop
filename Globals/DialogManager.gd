extends Node


signal display_dialog(text: String, anchor: Node2D)
signal display_action_dialog(options, anchor: Node2D)

func emit_display_dialog(text: String, anchor: Node2D) -> void:
	display_dialog.emit(text, anchor)

func emit_display_action_dialog(options, anchor: Node2D) -> void:
	display_action_dialog.emit(options, anchor)

var pending_dialog: Array = []
var current_dialog = {}
var current_dialog_idx: int = 0

var anchors: Dictionary = {
	"customer": null,
	"player": null
}


func set_anchor(key: String, anchor: Marker2D) -> void:
	anchors[key] = anchor


func start_dialog(dialogs: Array, customer_anchor: Marker2D) -> void:
	anchors["customer"] = customer_anchor
	
	pending_dialog = dialogs
	current_dialog = pending_dialog[current_dialog_idx]
	emit_display_dialog(current_dialog.value, anchors[current_dialog.speaker])

func advance_dialog() -> void:
	current_dialog_idx += 1
	current_dialog = pending_dialog[current_dialog_idx]
