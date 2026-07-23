extends VBoxContainer
class_name PrintDoneActionUI

signal pickup

@onready var panel = $PanelContainer
@onready var item_list = $PanelContainer/VBoxContainer/ItemUIList
@onready var pickup_btn = $Button

func show_items(items: Array[PrintItem]):
	var style = StyleBoxFlat.new()
	style.set_border_width_all(1)
	style.border_color = items[0].color
	style.bg_color = style.border_color
	style.bg_color.a = 0.05
	style.set_expand_margin_all(8)
	
	panel.add_theme_stylebox_override("panel", style)
	
	for item in items:
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(24,24)
		rect.color = item.color
		item_list.add_child(rect)
	show()


func _on_button_pressed():
	pickup.emit()
	hide()
	
	for item in item_list.get_children():
		item.queue_free()


func show_actions():
	pickup_btn.show()


func hide_actions():
	pickup_btn.hide()
