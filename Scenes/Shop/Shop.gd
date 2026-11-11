extends Control
class_name Shop

@onready var customers_manager: CustomersManager = %CustomersManager
@onready var shop_counter: ShopCounter = %ShopCounter
@onready var end_day_button: Button = $EndDayButton

func _ready() -> void:
	customers_manager.customer_enter.connect(_on_customer_enter)
	shop_counter.counter_updated.connect(_on_counter_updated)
	
	_generate_sample_items()

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
	print('Counter updated')
	_check_transaction()

func _check_transaction() -> void:
	var items_matched: bool = true
	for item_to_buy in current_customer_data.items_to_buy:
		items_matched = find_item_by_id(item_to_buy.id)
	
	print(items_matched)


func find_item_by_id(id: StringName) -> bool:
	for item in current_counter_items:
		if item.item_data.id == id:
			return true
	
	return false
#endregion Transation

#region Debug
const ITEM = preload("uid://f36ovkjjshuc")

@export var item_data_list: Array[ItemData] = []

@onready var items_manager: Control = $ItemsManager

func _generate_sample_items() -> void:
	for i in range(0, 3):
		var new_item: Item = ITEM.instantiate()
		
		var random_item_data: ItemData = item_data_list.pick_random()
		
		new_item.setup(random_item_data)
		new_item.global_position = Vector2(200 + 200 * i, 390)
		
		items_manager.add_child(new_item)
#endregion Debug
