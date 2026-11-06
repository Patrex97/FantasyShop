extends MarginContainer
class_name UI


@onready var day_label: Label = %DayLabel
@onready var customers_label: Label = %CustomersLabel


func _ready() -> void:
	GameManager.day_started.connect(_on_day_started)


func _on_day_started(customers_count: int, current_day: int) -> void:
	update_customers_label(customers_count)
	day_label.text = "Dzień: %d" % current_day


func update_customers_label(customers_count: int) -> void:
	customers_label.text = "Klientów zostało: %d" % customers_count
