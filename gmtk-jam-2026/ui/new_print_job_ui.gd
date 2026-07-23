extends PanelContainer
class_name NewPrintJobUI

signal accepted(NewPrintJob)

@export var job: PrintJob

@onready var countdown = $HBoxContainer/Countdown
@onready var accept_btn = $HBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	#countdown.start(job.accept_time)
	countdown.connect("timeout", _on_expired)

func _on_expired():
	queue_free()

func show_actions(_body):
	accept_btn.show()


func hide_actions(_body):
	accept_btn.hide()


func _on_button_pressed():
	accepted.emit(self)
