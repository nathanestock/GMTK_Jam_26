extends Control
class_name PrinterBasicActionUI

@export var tier: ThreeDPrinterTier
@export var action: String

@onready var label = $Label
@onready var ui = $TextureRect

func _draw():
	label.text = action
	
	if tier:
		label.modulate = tier.color
		ui.texture = tier.basic_action_ui
		ui.show()
	else:
		ui.hide()
