extends VBoxContainer
class_name MoneyCounterUI

var money: int = 0

@onready var money_label = $PanelContainer/Label
@onready var update_money_label = $Label
@onready var animation_player = $AnimationPlayer


func set_money(value: int):
	money = value


func add_money(value: int):
	money += value
	_update_money_label()
	_update_money_ui(value)
	


func _update_money_label():
	money_label.text = "$%d" % money


func _update_money_ui(value: int):
	update_money_label.text = "$%d" % value
	update_money_label.show()
	animation_player.play("money_update_fade")


func _on_animation_player_animation_finished(_anim_name):
	update_money_label.hide()
