extends HBoxContainer


var items: Array[PrintItem] = []


func clear():
	for c in get_children():
		c.queue_free()
		
	items.clear()


func add_item(item: PrintItem):
	items.append(item)
	
	var rect = ColorRect.new()
	rect.custom_minimum_size = Vector2(24,24)
	rect.color = item.color
	add_child(rect)


func set_items(_items: Array[PrintItem]):
	clear()
	for item in _items:
		add_item(item)
