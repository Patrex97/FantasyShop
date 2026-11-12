extends MarginContainer
class_name UI


@onready var day_label: Label = %DayLabel
@onready var customers_label: Label = %CustomersLabel
@onready var balance_label: Label = %BalanceLabel


func _ready() -> void:
	GameManager.day_started.connect(_on_day_started)
	GameManager.balance_changed.connect(_on_balance_changed)


func _on_balance_changed(new_balance: int) -> void:
	balance_label.text = str(new_balance)

#region Customers
func _on_day_started(customers_count: int, current_day: int) -> void:
	update_customers_label(customers_count)
	day_label.text = "Dzień: %d" % current_day


func update_customers_label(customers_count: int) -> void:
	customers_label.text = "Klientów zostało: %d" % customers_count
#endregion Customers
