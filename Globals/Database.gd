extends Node

var item_data_definitions: Array[ItemData] = []
var customer_data_definitions: Array[CustomerData] = []

func _ready() -> void:
	_load_item_data_definitions()
	_load_customer_data_definitions()


func _load_resources(path: String) -> Array[Resource]:
	var result: Array[Resource] = []
	
	for file_name in DirAccess.get_files_at(path):
		if not file_name.ends_with(".tres"):
			continue
		
		var resource = load(path.path_join(file_name))
		
		if resource:
			result.append(resource)
	
	return result

#region Loaders
func _load_item_data_definitions() -> void:
	var resources = _load_resources(
		"res://Classes/Items/Definitions"
	)
	
	for resource in resources:
		item_data_definitions.append(resource as ItemData)


func _load_customer_data_definitions() -> void:
	var resources = _load_resources(
		"res://Classes/Customers/Definitions"
	)
	
	for resource in resources:
		customer_data_definitions.append(resource as CustomerData)
#endregion Loaders
