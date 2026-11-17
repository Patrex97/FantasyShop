extends Control
class_name ShopCounter

const ITEM = preload("uid://f36ovkjjshuc")


@onready var counter_mc: MarginContainer = %CounterMC

@onready var items_manager: Control = %ItemsManager

var items: Array[Item]

#region Drag&Drop
func is_point_inside(global_point: Vector2) -> bool:
	return counter_mc.get_global_rect().has_point(global_point)
#endregion Drag&Drop

#region CounterList
@onready var counter_list: PanelContainer = %CounterList
@onready var title_label: Label = %TitleLabel
@onready var items_list: VBoxContainer = $CounterList/VBoxContainer/ItemsList

signal counter_updated(items: Array[Item])

func _update_counter_list() -> void:
	counter_updated.emit(items)
	
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


func spawn_items(items_datad: Array[ItemData]) -> void:
	for item_data in items_datad:
		_spawn_item(item_data)
	
	_update_counter_list()


func remove_items(items_to_remove: Array[Item]) -> void:
	for item in items_to_remove:
		remove_from_counter(item)
		item.queue_free()

func get_items_total_value() -> int:
	var total: int = 0
	
	for item in items:
		total += item.item_data.base_value
	
	return total
#endregion

#region Buy
func start_buy_transaction() -> void:
	title_label.text = 'Kupuje' # Klient kupuje
#endregion Buy

#region Sell
func start_sell_transaction(new_items: Array[ItemData]) -> void:
	spawn_items(new_items)
	title_label.text = 'Sprzedaje' # Klient sprzedaje

func items_sold() -> void:
	var shop_items_manager: Control = get_tree().get_first_node_in_group('ItemsManager')
	for item in items:
		item.reparent(shop_items_manager)
		item.draggable = true
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
func _spawn_item(item_data: ItemData) -> void:
	var new_item: Item = ITEM.instantiate()
	
	new_item.setup(item_data, false)
	
	var rect = counter_mc.get_rect()
	
	new_item.position = Vector2(rect.size.x / 2, rect.size.y / 2)
	items_manager.add_child(new_item)
	items.append(new_item)
#endregion helpers
