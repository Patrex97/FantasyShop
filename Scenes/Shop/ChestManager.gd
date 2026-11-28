extends Control
class_name ChestManager


const CHEST = preload("uid://bor1t0cgc2a0k")


var chest_list: Array[Chest] = []


func _ready() -> void:
	for i in range(GameManager.player_chest_count):
		_spawn_chest()


func _unhandled_input(event: InputEvent) -> void:
	for i in range(chest_list.size()):
		if event.is_action_pressed("Key%d" % (i + 1)):
			_toggle_chest(chest_list[i])
			return


func _spawn_chest() -> void:
	var new_chest: Chest = CHEST.instantiate()
	
	_add_items_to_chest()
	
	_close_chest(new_chest)
	
	add_child(new_chest)
	chest_list.append(new_chest)


func _add_items_to_chest() -> void:
	#Logika do uzupełnianai skrzyni zapisanymi przedmiotami po załadowaniu gry
	pass


func _toggle_chest(chest: Chest) -> void:
	if chest.visible: _close_chest(chest)
	else: _open_chest(chest)

func _open_chest(chest: Chest) -> void:
	chest.show()


func _close_chest(chest: Chest) -> void:
	chest.hide()
