extends Control
class_name CustomersManager

const CUSTOMER = preload("uid://cf3kwn74fxd4e")

@onready var end_day_button: Button = $"../EndDayButton"

@export var customers_data: Array[CustomerData]
@export var customers_left: int = 1
@export var UI_scene: UI


func _ready() -> void:
	GameManager.day_started.connect(_on_day_started)
	_start_customer_visit()

func end_customer_visit() -> void:
	_finish_customer_visit()


func _start_customer_visit() -> void:
	customers_left -= 1
	
	var new_customer_data: CustomerData = customers_data.pick_random()
	if not new_customer_data:
		return
	
	var new_customer: Customer = CUSTOMER.instantiate()
	new_customer.setup(new_customer_data)
	
	new_customer.global_position = Vector2(-200, 65)
	
	add_child(new_customer)
	
	UI_scene.update_customers_label(customers_left)


func _finish_customer_visit() -> void:
	var customer: Customer = get_child(0)
	
	await customer.walk_out()
	
	if customers_left > 0:
		_start_customer_visit()
	else:
		end_day_button.show()

func _on_day_started(customers_count: int, _current_day: int) -> void:
	customers_left = customers_count
	
	_start_customer_visit()
