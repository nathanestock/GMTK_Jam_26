extends Resource
class_name PrintJob

@export var duration: int = 0
@export var reward: int = 0
@export var items: Array[PrintItem] = []
@export var color: Color = Color.TRANSPARENT


func is_completed():
	return items.all(func (i): return i.is_completed())


func is_open():
	return items.any(func (i): return i.is_open())
