extends Control
class_name Shop

@onready var end_day_button: Button = $EndDayButton

func _on_end_day_button_pressed() -> void:
	GameManager.end_day()
	end_day_button.hide()

#region TEST
const ITEM = preload("uid://f36ovkjjshuc")

@export var item_data_list: Array[ItemData] = []

@onready var items: Control = $Items

func _ready() -> void:
	for i in range(0, 3):
		var new_item: Item = ITEM.instantiate()
		
		var random_item_data: ItemData = item_data_list.pick_random()
		
		new_item.setup(random_item_data)
		new_item.global_position = Vector2(200 + 200 * i, 390)
		
		items.add_child(new_item)

#endregion
