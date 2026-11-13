extends Control
class_name CustomersManager

const CUSTOMER = preload("uid://cf3kwn74fxd4e")

signal customer_enter(data: CustomerData)

@onready var end_day_button: Button = $"../EndDayButton"

@export var customers_data: Array[CustomerData]
@export var UI_scene: UI

func _ready() -> void:
	GameManager.day_started.connect(_on_day_started)

#region Queue
var customers_queue: Array[CustomerData] = []

func _fill_queue(customers_count: int) -> void:
	for i in range(customers_count):
		customers_queue.append(customers_data.pick_random())
#endregion Queue

#region Visit
var current_customer: Customer
var customer_visit: CustomerVisit

func _start_customer_visit() -> void:
	var new_customer_data: CustomerData = customers_queue.pop_front()
	
	customer_visit = CustomerVisit.new(new_customer_data, CustomerVisit.VisitType.Buy, )
	
	customer_enter.emit(customer_visit)
	
	var new_customer: Customer = CUSTOMER.instantiate()
	new_customer.setup(customer_visit)
	
	new_customer.global_position = Vector2(-200, 65)
	
	add_child(new_customer)
	
	current_customer = new_customer
	
	UI_scene.update_customers_label(customers_queue.size())


##For Dialogue
func end_customer_visit() -> void:
	_finish_customer_visit()


func _finish_customer_visit() -> void:
	var customer: Customer = get_child(0)
	
	await customer.walk_out()
	
	if customers_queue.size() > 0:
		_start_customer_visit()
	else:
		end_day_button.show()
	
	current_customer = null
#endregion Visit

#region Interactions
func trigger_dialogue(dialogue_name: String) -> void:
	if not current_customer:
		return
	
	current_customer.start_conversation(dialogue_name)

#endregion Interactions

func _on_day_started(customers_count: int, _current_day: int) -> void:
	_fill_queue(customers_count)
	
	_start_customer_visit()
