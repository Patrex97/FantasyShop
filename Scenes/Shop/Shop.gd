extends Control
class_name Shop

@onready var customers_manager: CustomersManager = %CustomersManager
@onready var shop_counter: ShopCounter = %ShopCounter
@onready var end_day_button: Button = $EndDayButton

func _ready() -> void:
	customers_manager.visit_state_changed.connect(_on_visit_state_changed)
	customers_manager.customer_enter.connect(_on_customer_enter)
	customers_manager.customer_left.connect(_on_customer_left)
	
	shop_counter.counter_updated.connect(_on_counter_updated)
	shop_counter.item_added.connect(_on_item_added)
	shop_counter.finalize_transaction.connect(_on_finalize_transaction)

func _on_end_day_button_pressed() -> void:
	GameManager.end_day()
	end_day_button.hide()

#region Transaction
var visit_state: CustomersManager.VisitState = CustomersManager.VisitState.Idle
var customer_visit: CustomerVisit


func _on_customer_enter(data: CustomerVisit) -> void:
	customer_visit = data


func _on_visit_state_changed(p_visit_state: CustomersManager.VisitState) -> void:
	visit_state = p_visit_state
	
	if visit_state == CustomersManager.VisitState.Finalized:
		shop_counter.clear_customer_items()


func _on_counter_updated() -> void:
	_check_transaction()


func start_transaction() -> void:
	match customer_visit.visit_type:
		CustomerVisit.VisitType.Buy:
			shop_counter.start_buy_transaction()
		CustomerVisit.VisitType.Sell:
			shop_counter.start_sell_transaction(customer_visit.items)
		_:
			print('start_ransaction: Nie ma logiki dla tego wariantu')
	
	_check_transaction()


func _check_transaction() -> void:
	if not customer_visit:
		return
	
	var can_finalize: bool = false
	
	if visit_state != CustomersManager.VisitState.Pending:
		return
	
	match customer_visit.visit_type:
		CustomerVisit.VisitType.Buy:
			var items_matched: bool = false
			if customer_visit:
				items_matched = not _find_all_matching_items().is_empty()
			
			if items_matched:
				can_finalize = true
		CustomerVisit.VisitType.Sell:
			var final_value: int = shop_counter.get_items_total_value(shop_counter.customer_items)
			can_finalize = final_value <= GameManager.player_balance
		_:
			print('check_transaction: Nie ma logiki dla tego wariantu')
	
	shop_counter.set_finalize_button_disabled(not can_finalize)


func _on_finalize_transaction() -> void:
	match customer_visit.visit_type:
		CustomerVisit.VisitType.Buy:
			var bought_items: Array[Item] = _find_all_matching_items()
			
			var total_value: int = shop_counter.get_items_total_value(bought_items)
			GameManager.change_balance(total_value)
			
			shop_counter.remove_items(bought_items)
			
			customers_manager.trigger_dialogue('item_bought')
		CustomerVisit.VisitType.Sell:
			var total_value: int = shop_counter.get_items_total_value(shop_counter.customer_items)
			GameManager.change_balance(-total_value)
			shop_counter.items_sold()
			
			customers_manager.trigger_dialogue('item_sold')
		_:
			print('on_finalize_transaction: Nie ma logiki dla tego wariantu')
	
	customer_visit = null
	shop_counter.set_finalize_button_disabled(true)


func _on_customer_left() -> void:
	customer_visit = null
#endregion Transation


#region Interactions

func _on_item_added(p_item: Item) -> void:
	if not customer_visit or visit_state != CustomersManager.VisitState.Pending:
		return
	
	match customer_visit.visit_type:
		CustomerVisit.VisitType.Buy:
			for item in customer_visit.items:
				if p_item.item_data.id == item.id:
					customers_manager.trigger_dialogue('item_approved')
		_:
			print('check_transaction: Nie ma logiki dla tego wariantu')

#endregion Interactions


#region Helpers
func _find_all_matching_items() -> Array[Item]:
	var matching_items: Array[Item]
	for item in customer_visit.customer_data.items_to_buy:
		var result: Item = shop_counter.find_item_by_id(item.id)
		if result != null:
			matching_items.append(result)
	
	return matching_items
#endregion Helpers
