extends Node

signal drag_started
signal drag_ended(items: Array[Control])

var nodes: Array[Control] = []
var drag_offsets: Dictionary = {}
var start_positions: Dictionary = {}

var is_dragging: bool = false


func _process(_delta: float) -> void:
	if not is_dragging:
		return
	
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	
	for node in nodes:
		if not is_instance_valid(node):
			continue
	
		node.global_position = mouse_position - drag_offsets[node]


func _input(event: InputEvent) -> void:
	if not is_dragging:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			drag_end()


func drag_start(p_nodes: Array[Control]) -> void:
	if is_dragging or p_nodes.is_empty():
		return
	
	nodes = p_nodes.duplicate()
	drag_offsets.clear()
	start_positions.clear()
	
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	
	for node in nodes:
		start_positions[node] = node.global_position
		drag_offsets[node] = mouse_position - node.global_position
		node.move_to_front()
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	is_dragging = true
	drag_started.emit()


func drag_end() -> void:
	if not is_dragging:
		return
	
	is_dragging = false
	
	drag_ended.emit(nodes)
	
	var hovered_control: Control = get_viewport().gui_get_hovered_control()
	
	
	for node in nodes:
		if is_instance_valid(node):
			node.mouse_filter = Control.MOUSE_FILTER_STOP
			if hovered_control is not InventoryGrid and node is Item:
				node.snap_back()
	
	nodes.clear()
	drag_offsets.clear()
	start_positions.clear()


func restore_positions() -> void:
	for node in nodes:
		if is_instance_valid(node) and start_positions.has(node):
			node.global_position = start_positions[node]
