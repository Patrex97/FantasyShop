extends Control
class_name ShopCounter


const ITEM = preload("uid://f36ovkjjshuc")


@onready var counter_mc: MarginContainer = %CounterMC
@onready var items_manager: Control = %ItemsManager


var items: Array[Item]
var customer_items: Array[Item]


#region Drag&Drop
func is_point_inside(global_point: Vector2) -> bool:
	return counter_mc.get_global_rect().has_point(global_point)
#endregion Drag&Drop


#region CounterList
@onready var counter_list: PanelContainer = %CounterList
@onready var title_label: Label = %TitleLabel
@onready var items_list: VBoxContainer = $CounterList/VBoxContainer/ItemsList


signal counter_updated


func _update_counter_list() -> void:
	counter_updated.emit()
	
	if not items.size():
		counter_list.hide()
		return
	
	for child in items_list.get_children():
		child.queue_free()
	
	var items_to_display: Array[Item] = customer_items if not customer_items.is_empty() else items
	
	for item in items_to_display:
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
#endregion CounterList

#region Items
signal item_added(item: Item)


func add_to_counter(new_item: Item) -> void:
	if items.has(new_item):
		return
	
	items.append(new_item)
	_update_counter_list()
	item_added.emit(new_item)


func remove_from_counter(item_to_remove: Item) -> void:
	if not items.has(item_to_remove):
		return
	
	items.erase(item_to_remove)
	customer_items.erase(item_to_remove)
	
	_update_counter_list()


func remove_items(items_to_remove: Array[Item]) -> void:
	for item in items_to_remove:
		remove_from_counter(item)
		item.queue_free()
#endregion Items


#region Buy
func start_buy_transaction() -> void:
	title_label.text = 'Kupuje' # Klient kupuje
	finalize_button.text = 'Sprzedaj'
#endregion Buy


#region Sell
func start_sell_transaction(new_items: Array[ItemData]) -> void:
	_spawn_items(new_items)
	title_label.text = 'Sprzedaje' # Klient sprzedaje
	finalize_button.text = "Kup"


func _spawn_items(items_data: Array[ItemData]) -> void:
	for item_data in items_data:
		var new_item: Item = ITEM.instantiate()
		
		new_item.setup(item_data, false)
		
		var rect = counter_mc.get_rect()
		
		new_item.position = Vector2(rect.size.x / 2, rect.size.y / 2)
		
		items_manager.add_child(new_item)
		
		items.append(new_item)
		customer_items.append(new_item)
	
	_update_counter_list()


func items_sold() -> void:
	var shop_items_manager: Control = get_tree().get_first_node_in_group('ItemsManager')
	for item in items:
		item.reparent(shop_items_manager)
		item.draggable = true
		item.modulate.a = 1
		
		customer_items.erase(item)
	
	_update_counter_list()
#endregion Sell


#region Finalize Button
@onready var finalize_button: Button = %FinalizeButton


signal finalize_transaction


func set_finalize_button_disabled(value: bool) -> void:
	finalize_button.disabled = value


func _on_finalize_button_pressed() -> void:
	#TODO: Przerobić na generyczne rozwiązanie
	finalize_transaction.emit()
#endregion Finalize Button

#region helpers
func get_items_total_value(p_items: Array[Item] = items) -> int:
	var total: int = 0
	
	for item in p_items:
		total += item.item_data.base_value
	
	return total


func find_item_by_id(id: StringName) -> Item:
	for item in items:
		if item.item_data.id == id:
			return item
	
	return null
#endregion helpers
