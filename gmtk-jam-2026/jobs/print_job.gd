extends Resource
class_name PrintJob

@export var duration: int = 0
@export var reward: int = 0
@export var items: Array[PrintItem] = []
@export var color: Color = Color.TRANSPARENT


func set_color(c: Color):
	color = c
	
	for item in items:
		item.color = c


func is_ready_to_ship():
	return items.all(func (i): return i.is_completed())


func get_unassigned_items() -> Array[PrintItem]:
	return items.filter(func (i): return i.is_unassigned())
