extends VBoxContainer
class_name PrintItemActionUI

signal print(items: Array[PrintItem])

@export var job: PrintJob
@export var max_items: int = 1

@onready var panel = $PanelContainer
@onready var time_label = $PanelContainer/VBoxContainer/PrintTimeLabel
@onready var item_list = $PanelContainer/VBoxContainer/ItemListUI

var print_items: Array[PrintItem] = []

func _ready():
	var style = StyleBoxFlat.new()
	style.set_border_width_all(1)
	style.border_color = job.color
	style.bg_color = job.color
	style.bg_color.a = 0.05
	style.set_expand_margin_all(8)
	
	panel.add_theme_stylebox_override("panel", style)
	
	var open_items = job.items.filter(func (i): return i.is_open())
	
	for item in open_items:
		print_items.append(item)
		
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(24,24)
		rect.color = job.color
		item_list.add_child(rect)
		
		if print_items.size() >= max_items:
			break
	
	time_label.text = "T: %d" % print_items.map(func (i): return i.print_time).max()

func _on_button_pressed():
	print.emit(print_items)
