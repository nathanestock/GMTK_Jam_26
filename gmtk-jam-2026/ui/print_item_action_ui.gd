extends PanelContainer
class_name PrintItemActionUI

signal print(items: Array[PrintItem])

@export var job: PrintJob
@export var max_items: int = 1

@onready var countdown = $VBoxContainer/Countdown
@onready var item_list = $VBoxContainer/HBoxContainer

var print_items: Array[PrintItem] = []

func _ready():
	var open_items = job.items.filter(func (i): return i.is_open())
	
	for item in open_items:
		print_items.append(item)
		
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(24,24)
		rect.color = job.color
		item_list.add_child(rect)
		
		if print_items.size() >= max_items:
			break

func _on_button_pressed():
	print.emit(print_items)
