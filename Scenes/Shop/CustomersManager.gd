extends Node2D
class_name CustomersManager

const CUSTOMER = preload("uid://cf3kwn74fxd4e")

var customers_left: int = 3

func _ready() -> void:
	_start_customer_visit()

func end_customer_visit() -> void:
	_finish_customer_visit()


func _start_customer_visit() -> void:
	customers_left -= 1
	
	var new_customer: Customer = CUSTOMER.instantiate()
	
	new_customer.global_position = Vector2(-200, 65)
	
	add_child(new_customer)


func _finish_customer_visit() -> void:
	var customer: Customer = get_child(0)
	
	await customer.walk_out()
	
	if customers_left > 0:
		_start_customer_visit()
