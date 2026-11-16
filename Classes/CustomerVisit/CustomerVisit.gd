extends Resource
class_name CustomerVisit

enum VisitType {
	Buy,
	Sell
}

@export var item_data: Array[ItemData] = Database.item_data_definitions

@export var customer_data: CustomerData
@export var visit_type: VisitType
@export var gold: int
@export var items: Array[ItemData] = []

func _init(
	p_customer_data: CustomerData,
	p_visit_type: VisitType,
) -> void:
	customer_data = p_customer_data
	visit_type = p_visit_type
	gold = randi_range(p_customer_data.min_gold, p_customer_data.max_gold)
	for i in range(3):
		items.append(item_data.pick_random().duplicate())
	
