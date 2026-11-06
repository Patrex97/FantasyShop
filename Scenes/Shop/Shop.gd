extends Control
class_name Shop

@onready var end_day_button: Button = $EndDayButton

func _on_end_day_button_pressed() -> void:
	GameManager.end_day()
	end_day_button.hide()
