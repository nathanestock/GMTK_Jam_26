extends HBoxContainer
class_name NewPrintJobUI

signal accepted(NewPrintJobUI)
signal expired(PrintJob)

@export var job: PrintJob

@onready var panel = $PanelContainer
@onready var countdown = $PanelContainer/VBoxContainer/Countdown
@onready var accept_btn = $Button
@onready var items_list = $PanelContainer/VBoxContainer/ItemUIList
@onready var time_label = $PanelContainer/VBoxContainer/HBoxContainer/PrintTimeLabel
@onready var material_label = $PanelContainer/VBoxContainer/HBoxContainer/MaterialLabel
@onready var reward_label = $PanelContainer/VBoxContainer/HBoxContainer/RewardLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in job.items:
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(24,24)
		rect.color = job.color
		items_list.add_child(rect)
	
	time_label.text = "T: %d" % job.get_total_time()
	material_label.text = "M: %d" % job.get_total_material()
	reward_label.text = "+ $%d" % job.reward
	
	countdown.start(job.accept_time)
	countdown.connect("timeout", _on_expired)
	
	var style = StyleBoxFlat.new()
	style.set_border_width_all(1)
	style.border_color = job.color
	style.bg_color = job.color
	style.bg_color.a = 0.05
	style.set_expand_margin_all(8)
	
	panel.add_theme_stylebox_override("panel", style)

func _on_expired():
	expired.emit(job)
	queue_free()

func show_actions(_body):
	accept_btn.show()


func hide_actions(_body):
	accept_btn.hide()


func _on_button_pressed():
	accepted.emit(self)
