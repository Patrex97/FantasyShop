extends Node

signal day_started(customers_count: int, current_day: int)
signal day_ended

func emit_day_started(customers_count: int) -> void:
	day_started.emit(customers_count, current_day)

func emit_day_ended() -> void:
	day_ended.emit()

var current_day: int = 1

func end_day() -> void:
	emit_day_ended()
	start_day()


func start_day() -> void:
	current_day += 1
	var new_customers: int = randi_range(1, 3)
	emit_day_started(new_customers)
