extends Resource
class_name PrintJob

@export var duration: int
@export var cost: int
@export var reward: int
@export var items: Array[PrintItem]
@export var color: Color
@export var item_type: AtlasTexture


func set_color(c: Color):
	color = c
	
	for item in items:
		item.color = c


func is_ready_to_ship():
	return items.all(func (i): return i.is_picked_up())


func get_unassigned_items() -> Array[PrintItem]:
	return items.filter(func (i): return i.is_unassigned())


func get_total_time():
	var total = 0
	for item in items:
		total += item.print_time
	return total
