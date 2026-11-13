extends Resource
class_name CustomerVisit

enum VisitType {
	Buy,
	Sell
}

@export var customer_data: CustomerData
@export var visit_type: VisitType
@export var gold: int

func _init(
	p_customer_data: CustomerData,
	p_visit_type: VisitType,
) -> void:
	customer_data = p_customer_data
	visit_type = p_visit_type
	gold = randi_range(p_customer_data.min_gold, p_customer_data.max_gold)
