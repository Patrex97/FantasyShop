extends Container
class_name ShopCounter

var items: Array[Item]

func is_point_inside(global_point: Vector2) -> bool:
	return get_global_rect().has_point(global_point)


func add_to_counter(new_item: Item) -> void:
	if items.has(new_item):
		return
	
	items.append(new_item)

func remove_from_counter(item_to_remove: Item) -> void:
	if not items.has(item_to_remove):
		return
	
	items.erase(item_to_remove)

#region Debug
@onready var label: Label = $Label

func _process(_delta: float) -> void:
	label.text = str(items.size())
#endregion
