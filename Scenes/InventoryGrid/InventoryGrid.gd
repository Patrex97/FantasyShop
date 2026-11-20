extends Control
class_name InventoryGrid

const CELL_SIZE: int = 16

@export_range(1, 100) var rows: int = 10
@export_range(1, 100) var cols: int = 10

var sample_item: Item = Item.new()

var cells: Dictionary = {
	Vector2i(0, 1): sample_item
}

func _ready() -> void:
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


func _is_inside_grid(p_item: Item) -> bool:
	var item_coords = _get_item_coords(p_item)
	
	return 	item_coords.pos.x >= 0 and \
	item_coords.pos.x + item_coords.size.x <= cols and \
	item_coords.pos.y >= 0 and \
	item_coords.pos.y + item_coords.size.y <= rows

func _can_place_item(p_item: Item) -> bool:
	var item_coords = _get_item_coords(p_item)
	
	for y in range(item_coords.pos.y, item_coords.pos.y + item_coords.size.y):
		for x in range(item_coords.pos.x, item_coords.pos.x + item_coords.size.x):
			if _is_cell_occupied(Vector2i(x, y), p_item):
				return false
	
	return true

func _get_item_coords(p_item: Item) -> Dictionary:
	var item_size: Vector2i = p_item.item_data.grid_size
	var item_local_pos: Vector2 = p_item.global_position - global_position
	var item_coords: Vector2i = floor(item_local_pos / CELL_SIZE)
	
	return { 'pos': item_coords, 'size': item_size }

func _assign_item(p_item: Item) -> void:
	var item_coords = _get_item_coords(p_item)
	
	for y in range(item_coords.pos.y, item_coords.pos.y + item_coords.size.y):
		for x in range(item_coords.pos.x, item_coords.pos.x + item_coords.size.x):\
			cells[Vector2i(x, y)] = p_item
	
	queue_redraw()

func _clear_item_cells(p_item: Item) -> void:
	for coords in cells.keys():
		if cells[coords].is_same(p_item):
			cells.erase(coords)
	
	queue_redraw()

func _drag_over(p_item: Item) -> void:
	if _is_inside_grid(p_item) and _can_place_item(p_item):
		print('Can drop')


func _drop(p_item: Item) -> void:
	if not (_is_inside_grid(p_item) and _can_place_item(p_item)):
		return
	
	_clear_item_cells(p_item)
	
	_assign_item(p_item)
