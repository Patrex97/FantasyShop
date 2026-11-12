extends Node

#region Time
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
#endregion Time

#region Money
var player_balance: int = 10

func change_balance(value: int) -> bool:
	if value < 0 and abs(value) > player_balance:
		print('Nie masz tyle pieniedzy')
		return false
	
	player_balance += value
	emit_player_balance()
	return true

signal balance_changed(new_balance: int)

func emit_player_balance() -> void:
	balance_changed.emit(player_balance)

#endregion Money
