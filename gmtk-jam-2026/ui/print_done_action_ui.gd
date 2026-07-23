extends PanelContainer
class_name PrintDoneActionUI

signal pickup

@onready var item_list = $VBoxContainer/HBoxContainer
@onready var pickup_btn = $VBoxContainer/Button

func show_items(items: Array[PrintItem]):
	for item in items:
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(24,24)
		rect.color = item.color
		item_list.add_child(rect)
	show()


func _on_button_pressed():
	pickup.emit()
	hide()


func show_actions():
	pickup_btn.show()


func hide_actions():
	pickup_btn.hide()
