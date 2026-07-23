extends Resource
class_name PrintJob

@export var accept_time: int = 0
@export var reward: int = 0
@export var items: Array[PrintItem] = []
@export var color: Color = Color.TRANSPARENT


func get_total_time() -> int:
	var total = accept_time
	for item in items:
		total += item.print_time
	return total


func set_item_colors():
	for item in items:
		item.color = color


func is_completed():
	return items.all(func (i): return i.is_completed())


func is_open():
	return items.any(func (i): return i.is_open())
