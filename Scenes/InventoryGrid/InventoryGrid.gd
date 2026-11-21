extends Control
class_name InventoryGrid

const CELL_SIZE: int = 16

@export_range(1, 100) var rows: int = 10
@export_range(1, 100) var cols: int = 10


const IRON_SWORD = preload("uid://cguoffsyid1d7")
const ITEM = preload("uid://f36ovkjjshuc")
var sample_item: Item = ITEM.instantiate()

var cells: Dictionary = {}

func _ready() -> void:
	sample_item.setup(IRON_SWORD)
	_assign_item(sample_item)
	
	size = Vector2(CELL_SIZE * cols, CELL_SIZE  * rows)

func _draw() -> void:
	for y in range(rows):
		var row_pos: int = CELL_SIZE * y
		for x in range(cols):
			var col_pos: int = CELL_SIZE * x
			var cell_color: Color = Color('red') if _is_cell_occupied(Vector2i(x, y)) else Color('gray')
			
			draw_rect(Rect2i(col_pos, row_pos, CELL_SIZE, CELL_SIZE), cell_color, false)


func _is_cell_occupied(coords: Vector2i, ignored_item: Item = null) -> bool:
	if not cells.has(coords):
		return false
	
	if ignored_item == null:
		return true
	
	return not cells[coords].is_same(ignored_item)


func _is_inside_grid(item_placement: Dictionary) -> bool:
	for shape_coords in item_placement.shape:
		var coords: Vector2i = item_placement.pos + shape_coords
	
		if coords.x < 0 or coords.x >= cols or \
			coords.y < 0 or coords.y >= rows:
			return false
	
	return true


func _can_place_item(p_item: Item) -> bool:
	var item_placement = _get_item_placement(p_item)
	
	if item_placement.shape.is_empty():
		return false
	
	if not _is_inside_grid(item_placement):
		return false
	
	for shape_coords in item_placement.shape:
		if _is_cell_occupied(shape_coords + item_placement.pos, p_item):
			return false
	
	return true

func _get_item_placement(p_item: Item) -> Dictionary:
	var grid_shape: Array[Vector2i] = p_item.item_data.grid_shape
	var item_local_pos: Vector2 = p_item.global_position - global_position
	var item_placement: Vector2i = floor(item_local_pos / CELL_SIZE)
	
	return { 'pos': item_placement, 'shape': grid_shape }

func _assign_item(p_item: Item) -> void:
	var item_placement = _get_item_placement(p_item)
	
	for shape_coords in item_placement.shape:
		cells[shape_coords + item_placement.pos] = p_item
	
	add_child(p_item)
	p_item.position = item_placement.pos
	
	queue_redraw()

func _clear_item_cells(p_item: Item) -> void:
	for coords in cells.keys():
		if cells[coords].is_same(p_item):
			cells.erase(coords)
	
	queue_redraw()

func _drag_over(p_item: Item) -> void:
	if _can_place_item(p_item):
		print('Can drop')


func _drop(p_item: Item) -> void:
	if not _can_place_item(p_item):
		return
	
	_clear_item_cells(p_item)
	
	_assign_item(p_item)
