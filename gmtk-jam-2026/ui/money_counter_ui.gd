extends Control
class_name MoneyCounterUI

@export var total: int = 1000

var money: int = 0

@onready var money_label = $CanvasGroup/VBoxContainer/HBoxContainer/Count
@onready var update_money_label = $CanvasGroup/VBoxContainer/Update
@onready var total_label = $CanvasGroup/VBoxContainer/HBoxContainer/Total


func _ready():
	update_money_label.hide()
	total_label.text = "/ %s" % FormatHelpers.money_str(total, false)


func set_money(value: int):
	money = value
	_update_money_label()


func add_money(value: int):
	money += value
	_update_money_label()
	_update_money_ui(value)
	


func _update_money_label():
	money_label.text = FormatHelpers.money_str(money)


func _update_money_ui(value: int):
	update_money_label.text = "$%d" % value
	
	if value < 0:
		update_money_label.text = "- %s" % FormatHelpers.money_str(value)
		update_money_label.modulate = Color.RED
	else:
		update_money_label.text = "+ %s" % FormatHelpers.money_str(value)
		update_money_label.modulate = Color.GREEN
	
	update_money_label.modulate.a = 1.0
	update_money_label.show()
	
	var tween := create_tween()
	tween.tween_property(update_money_label, "modulate:a", 0.0, 1.0).set_delay(2)
	tween.tween_callback(update_money_label.hide)
