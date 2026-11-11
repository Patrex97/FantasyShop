extends Control
class_name ShopCounter

@onready var counter_mc: MarginContainer = %CounterMC


var items: Array[Item]

func is_point_inside(global_point: Vector2) -> bool:
	return counter_mc.get_global_rect().has_point(global_point)


func add_to_counter(new_item: Item) -> void:
	if items.has(new_item):
		return
	
	items.append(new_item)
	_update_counter_list()

func remove_from_counter(item_to_remove: Item) -> void:
	if not items.has(item_to_remove):
		return
	
	items.erase(item_to_remove)
	_update_counter_list()

#region CounterList
@onready var counter_list: PanelContainer = %CounterList
@onready var items_list: VBoxContainer = $CounterList/VBoxContainer/ItemsList



func _update_counter_list() -> void:
	if not items.size():
		counter_list.hide()
		return
	
	for child in items_list.get_children():
		child.queue_free()
	
	for item in items:
		var item_data: ItemData = item.item_data
		
		var row: HBoxContainer = HBoxContainer.new()
		
		var name_label: Label = Label.new()
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_label.text = "%s" % item_data.name
		
		row.add_child(name_label)
		
		var price_label: Label = Label.new()
		price_label.text = "%d G" % item_data.base_value
		
		row.add_child(price_label)
		
		items_list.add_child(row)
	
	counter_list.show()
#endregion
