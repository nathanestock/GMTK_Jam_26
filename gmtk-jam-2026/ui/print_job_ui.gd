extends PanelContainer
class_name PrintJobUI

@export var job: PrintJob

@onready var countdown = $VBoxContainer/Countdown
@onready var items_list = $VBoxContainer/ItemUIList
@onready var reward_label = $VBoxContainer/RewardLabel

var completed_items: Array[PrintItem] = []

func _ready():
	var style = StyleBoxFlat.new()
	style.set_border_width_all(1)
	style.border_color = job.color
	style.bg_color = style.border_color
	style.bg_color.a = 0.05
	style.set_expand_margin_all(8)
	
	add_theme_stylebox_override("panel", style)
	
	countdown.start(job.get_total_time())
	
	for item in job.items:
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(24,24)
		rect.color = job.color
		rect.color.a = 0.2
		items_list.add_child(rect)
	
	reward_label.text = "+ $%d" % job.reward


func _on_countdown_timeout():
	queue_free()


func update_items():
	var i = 0
	for item in job.items:
		var ui = items_list.get_child(i) as ColorRect
		if item.is_completed():
			ui.color.a = 1.0
		elif item.is_printing():
			ui.color.a = 0.5
		
		i += 1
