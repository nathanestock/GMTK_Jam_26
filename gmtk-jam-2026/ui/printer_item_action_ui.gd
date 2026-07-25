extends Control
class_name PrinterItemActionUI

@export var tier: ThreeDPrinterTier
@export var action: String
@export var second_action: String
@export var hide_basic_action: bool = false

@onready var label = $Label
@onready var grid_ui = $ItemGridUI/GridTexture
@onready var grid_ui_container = $ItemGridUI
@onready var basic_action = $PrinterBasicActionUI
@onready var item1 = $ItemGridUI/Item1
@onready var item2 = $ItemGridUI/Item2
@onready var item3 = $ItemGridUI/Item3
@onready var item4 = $ItemGridUI/Item4

var items: Array[PrintItem]


func _ready():
	item1.hide()
	item2.hide()
	item3.hide()
	item4.hide()
	
	if hide_basic_action:
		basic_action.hide()


func _draw():
	label.text = action
	label.modulate = tier.color
	basic_action.action = second_action
	basic_action.tier = tier
	grid_ui.texture = tier.item_action_ui
	
	grid_ui_container.custom_minimum_size = grid_ui.texture.get_region().size


func set_items(_items: Array[PrintItem]):
	items = _items
	
	item1.hide()
	item2.hide()
	item3.hide()
	item4.hide()
	
	var item_type = items[0].job.item_type
	var color = items[0].job.color
	
	for i in range(tier.item_ui_positions.size()):
		var pos = tier.item_ui_positions[i]
		if i == 0:
			item1.position = pos
			item1.texture = item_type
			item1.modulate = color
			item1.show()
		elif i == 1:
			item2.position = pos
			item2.texture = item_type
			item2.modulate = color
			item2.show()
		elif i == 2:
			item3.position = pos
			item3.texture = item_type
			item3.modulate = color
			item3.show()
		elif i == 3:
			item4.position = pos
			item4.texture = item_type
			item4.modulate = color
			item4.show()
		
		if i == items.size() - 1:
			break
