extends Control
class_name Shop

@onready var customers_manager: CustomersManager = %CustomersManager
@onready var shop_counter: ShopCounter = %ShopCounter
@onready var end_day_button: Button = $EndDayButton

func _ready() -> void:
	customers_manager.customer_enter.connect(_on_customer_enter)
	shop_counter.counter_updated.connect(_on_counter_updated)
	shop_counter.sell.connect(_on_sell)

func _on_end_day_button_pressed() -> void:
	GameManager.end_day()
	end_day_button.hide()

#region Transaction
var current_customer_data: CustomerData 
var current_counter_items: Array[Item]

func _on_customer_enter(data: CustomerData) -> void:
	current_customer_data = data
	print('Customer entered')

func _on_counter_updated(items: Array[Item]) -> void:
	current_counter_items = items
	_check_transaction()

func _check_transaction() -> void:
	var items_matched: bool = true
	if current_customer_data:
		items_matched = _find_all_matching_items().size() > 0
	
	if items_matched:
		customers_manager.trigger_dialogue('item_approved')
		shop_counter.toggle_sell_button(true)



func _find_item_by_id(id: StringName) -> Item:
	for item in current_counter_items:
		if item.item_data.id == id:
			return item
	
	return null


func _find_all_matching_items() -> Array[Item]:
	var matching_items: Array[Item]
	for item in current_customer_data.items_to_buy:
		var result: Item = _find_item_by_id(item.id)
		if result != null:
			matching_items.append(result)
	
	return matching_items


func _get_total_value(items: Array[Item]) -> int:
	var total: int = 0
	
	for item in items:
		total += item.item_data.base_value
	
	return total


func _on_sell() -> void:
	var sold_items: Array[Item] = _find_all_matching_items()
	
	var total_value: int = _get_total_value(sold_items)
	GameManager.change_balance(total_value)
	
	shop_counter.remove_items(sold_items)
	shop_counter.toggle_sell_button(false)
	
	customers_manager.trigger_dialogue('item_bought')

#endregion Transation
