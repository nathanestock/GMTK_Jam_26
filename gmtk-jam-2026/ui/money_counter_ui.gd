extends Control
class_name MoneyCounterUI



var money: int = 0

@onready var money_label = $CanvasGroup/VBoxContainer/HBoxContainer/Count
@onready var update_money_label = $CanvasGroup/VBoxContainer/Update
@onready var total_label = $CanvasGroup/VBoxContainer/HBoxContainer/Total


func _ready():
	update_money_label.hide()
	


func set_money(value: int):
	money = value
	_update_money_label()


func set_total(value: int):
	total_label.show()
	
	total_label.text = "/ %s" % FormatHelpers.money_str(value, false)


func set_zen_mode():
	total_label.hide()


func add_money(value: int):
	money += value
	_update_money_label()
	_update_money_ui("+ %s" % FormatHelpers.money_str(value), Color.GREEN)


func remove_money(value: int) -> bool:
	if (money - value < 0):
		_update_money_ui("Nope!", Color.RED)
		return false
	
	money -= value
	_update_money_label()
	_update_money_ui("- %s" % FormatHelpers.money_str(value), Color.RED)
	
	return true


func _update_money_label():
	money_label.text = FormatHelpers.money_str(money)


func _update_money_ui(str: String, color: Color):
	update_money_label.text = str
	update_money_label.modulate = color
	
	update_money_label.modulate.a = 1.0
	update_money_label.show()
	
	var tween := create_tween()
	tween.tween_property(update_money_label, "modulate:a", 0.0, 1.0).set_delay(2)
	tween.tween_callback(update_money_label.hide)
