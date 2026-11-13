extends Resource
class_name CustomerData

@export var id: StringName
@export var name: String
@export var texture: Texture2D
@export var min_gold: int
@export var max_gold: int
@export var items_to_buy: Array[ItemData]
@export var items_to_sell: Array[ItemData]
