
class_name InventoryGrid
extends Control


const CELL_SIZE: int = 16
const IRON_SWORD = preload("uid://cguoffsyid1d7")
const ITEM = preload("uid://f36ovkjjshuc")

@export var debug: bool = true
@export_range(1, 100) var rows: int = 10
@export_range(1, 100) var cols: int = 10


var cells: Dictionary = {}
var hovered_cells: Dictionary = {}
var is_hover_conflict: bool = false


#region Lifecycle
func _ready() -> void:
	custom_minimum_size = Vector2(CELL_SIZE * cols, CELL_SIZE * rows)

func _process(_delta: float) -> void:
	var old_hovered_cells: Dictionary = {}
	var old_is_hover_conflict: bool = is_hover_conflict
	if not hovered_cells.is_empty():
		is_hover_conflict = false
		old_hovered_cells = hovered_cells.duplicate()
		hovered_cells.clear() 
	
	if DragDropManager.is_dragging:
		for node in DragDropManager.nodes:
			if not get_global_rect().intersects(node.get_global_rect()):
				continue
			if node is not Item:
				continue
			
			var item_placement: Dictionary = _get_item_placement(node)
			for shape_coords in item_placement.shape:
				var coords: Vector2i = item_placement.coords + shape_coords
				hovered_cells[coords] = node
			
			if not is_hover_conflict:
				for h_coords in hovered_cells.keys():
					if _is_cell_occupied(h_coords, node) or not _is_cell_inside_grid(h_coords):
						is_hover_conflict = true
						break;
		
	if hovered_cells != old_hovered_cells or \
		old_is_hover_conflict != is_hover_conflict:
			queue_redraw()
#endregion


#region Drawing
func _draw() -> void:
	for y in range(rows):
		for x in range(cols):
			var cell_color: Color = _get_cell_color(Vector2i(x, y))
		
			if cell_color == Color("6d6d6dff"):
				continue
		
			var cell_rect: Rect2i = Rect2i(
				x * CELL_SIZE,
				y * CELL_SIZE,
				CELL_SIZE,
				CELL_SIZE
			)
			
			draw_rect(cell_rect, cell_color, true)
	
	_draw_grid()


func _get_cell_color(coords: Vector2i) -> Color:
	var cell_color: Color = Color("6d6d6dff")
	if hovered_cells.has(coords):
		cell_color = Color(Color("red"), 0.3) if is_hover_conflict else Color(Color('green'), 0.3) 
	elif debug and _is_cell_occupied(coords):
		cell_color = Color("blue") 
	
	return cell_color


func _draw_grid() -> void:
	var grid_color: Color = Color("abababff")
	var grid_width: int = cols * CELL_SIZE
	var grid_height: int = rows * CELL_SIZE

	for x in range(cols + 1):
		var x_pos: int = x * CELL_SIZE

		draw_line(
			Vector2(x_pos, 0),
			Vector2(x_pos, grid_height),
			grid_color,
			-1.0
		)

	for y in range(rows + 1):
		var y_pos: int = y * CELL_SIZE

		draw_line(
			Vector2(0, y_pos),
			Vector2(grid_width, y_pos),
			grid_color,
			-1.0
		)
#endregion


#region Grid Validation
func _can_place_item(p_item: Item, item_placement: Dictionary) -> bool:
	if item_placement.shape.is_empty():
		return false
	
	if not _is_inside_grid(item_placement):
		return false
	
	for shape_coords in item_placement.shape:
		if _is_cell_occupied(shape_coords + item_placement.coords, p_item):
			return false
	
	return true


func _is_inside_grid(item_placement: Dictionary) -> bool:
	for shape_coords in item_placement.shape:
		var coords: Vector2i = item_placement.coords + shape_coords
		
		if not _is_cell_inside_grid(coords):
			return false
	
	return true

func _is_cell_inside_grid(coords: Vector2i) -> bool:
	if coords.x < 0 or coords.x >= cols or \
		coords.y < 0 or coords.y >= rows:
			return false
	
	return true

func _is_cell_occupied(coords: Vector2i, ignored_item: Item = null) -> bool:
	if not cells.has(coords):
		return false
	
	if ignored_item == null:
		return true
	
	return not cells[coords] == ignored_item
#endregion


#region Item Placement
func _drop(p_item: Item) -> void:
	var item_placement = _get_item_placement(p_item)
	
	if not _can_place_item(p_item, item_placement):
		DragDropManager.restore_positions()
		return
	
	
	_assign_item(p_item, item_placement)


#Used for programically add item into first empty slot (e.g. Customer items when visit starts)
func add_item(p_item: Item) -> bool:
	var item_placement: Dictionary = {
		'coords': Vector2i.ZERO,
		'shape': p_item.item_data.grid_shape
	}
	
	item_placement['coords'] = _find_available_position(p_item, item_placement['shape'])

	if item_placement['coords'] == Vector2i(-1, -1):
		return false

	_assign_item(p_item, item_placement)

	return true


func remove_item(p_item: Item) -> bool:
	if p_item.get_parent() != self:
		return false
	
	clear_item_cells(p_item)
	p_item.queue_free()
	
	return true

func _find_available_position(p_item: Item, item_shape: Array[Vector2i]) -> Vector2i:
	var item_placement: Dictionary = {
		"coords": Vector2i.ZERO,
		"shape": item_shape
	}

	for y in range(rows):
		for x in range(cols):
			item_placement.coords = Vector2i(x, y)

			if _can_place_item(p_item, item_placement):
				return item_placement.coords

	return Vector2i(-1, -1)


func _get_item_placement(p_item: Item) -> Dictionary:
	var grid_shape: Array[Vector2i] = p_item.item_data.grid_shape
	var item_local_pos: Vector2 = p_item.global_position - global_position
	var item_coords: Vector2i = round(item_local_pos / CELL_SIZE)
	
	return {
		"pos": item_local_pos,
		"coords": item_coords,
		"shape": grid_shape
	}


func _assign_item(p_item: Item, item_placement: Dictionary) -> void:
	var item_parent: Node = p_item.get_parent()
	
	if item_parent is InventoryGrid:
		item_parent.clear_item_cells(p_item)
	
	for shape_coords in item_placement.shape:
		cells[shape_coords + item_placement.coords] = p_item
	
	if item_parent == null:
		add_child(p_item)
	elif item_parent != self:
		p_item.reparent(self)
	
	p_item.position = item_placement.coords * CELL_SIZE
	
	queue_redraw()


func clear_item_cells(p_item: Item) -> void:
	for coords in cells.keys():
		if cells[coords] == p_item:
			cells.erase(coords)
	
	queue_redraw()
#endregion


#region Signal Handlers
func _on_drag_ended(items: Array[Control]) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	
	if not get_global_rect().has_point(mouse_position):
		return
	
	for node in items:
		if node is Item:
			_drop(node)


func _on_mouse_entered() -> void:
	if not DragDropManager.drag_ended.is_connected(_on_drag_ended):
		DragDropManager.drag_ended.connect(_on_drag_ended)


func _on_mouse_exited() -> void:
	if DragDropManager.drag_ended.is_connected(_on_drag_ended):
		DragDropManager.drag_ended.disconnect(_on_drag_ended)
#endregion
