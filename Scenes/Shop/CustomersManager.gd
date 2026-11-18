extends Control
class_name CustomersManager

enum VisitState {
	Idle,
	Approaching,
	NotStarted,
	Pending,
	Finalized
}

const CUSTOMER = preload("uid://cf3kwn74fxd4e")

signal customer_enter(data: CustomerVisit)

@onready var end_day_button: Button = $"../EndDayButton"

@export var customers_data: Array[CustomerData]
@export var UI_scene: UI

var visit_state: VisitState = VisitState.Idle

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
	if customers_queue.is_empty():
		end_day_button.show()
		return
	
	visit_state = VisitState.Approaching
	
	var visit_type: CustomerVisit.VisitType = randi_range(0, 1) as CustomerVisit.VisitType
	
	var new_customer_data: CustomerData = customers_queue.pop_front()
	customer_visit = CustomerVisit.new(new_customer_data, visit_type)
	
	customer_enter.emit(customer_visit)
	
	var new_customer: Customer = CUSTOMER.instantiate()
	new_customer.setup(customer_visit)
	add_child(new_customer)
	new_customer.global_position = Vector2(-200, 65)
	
	current_customer = new_customer
	
	UI_scene.update_customers_label(customers_queue.size())
	
	await new_customer.walk_in()
	
	new_customer.clicked.connect(_on_customer_clicked)
	
	visit_state = VisitState.NotStarted


##For Dialogue
func end_customer_visit() -> void:
	_finish_customer_visit()


func _finish_customer_visit() -> void:
	if visit_state != VisitState.Pending:
		return
	
	visit_state = VisitState.Finalized
	
	await current_customer.walk_out()
	
	current_customer.queue_free()
	current_customer = null
	
	visit_state = VisitState.Idle
	
	if customers_queue.size() > 0:
		_start_customer_visit()
	else:
		end_day_button.show()
#endregion Visit

#region Interactions
func _on_customer_clicked() -> void:
	match visit_state:
		VisitState.NotStarted:
			trigger_dialogue("start")
			visit_state = VisitState.Pending
		VisitState.Pending:
			_finish_customer_visit()
		_:
			pass
			

func trigger_dialogue(dialogue_name: String) -> void:
	if not current_customer:
		return
	
	current_customer.start_conversation(dialogue_name)
#endregion Interactions

func _on_day_started(customers_count: int, _current_day: int) -> void:
	_fill_queue(customers_count)
	
	_start_customer_visit()
