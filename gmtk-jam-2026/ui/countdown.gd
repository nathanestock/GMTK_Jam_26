extends HBoxContainer
class_name Countdown

signal timeout

@onready var label = $Label
@onready var timer = $Timer


func _process(_delta):
	if not timer.is_stopped():
		label.text = str(int(timer.time_left))


func start(time: int):
	timer.start(time)


func stop():
	timer.stop()


func set_label(text: String):
	label.text = text


func _on_timer_timeout():
	timeout.emit()
