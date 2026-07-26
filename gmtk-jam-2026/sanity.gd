extends Control
class_name SanityUI

signal out_of_sanity
signal alert

const sanity_levels = 6
const sanity_drain_rate = 1.0
const alert_at = 2 # Level to alert

const sanity_0 = preload("res://assets/sanity_0.tres")
const sanity_1 = preload("res://assets/sanity_1.tres")
const sanity_2 = preload("res://assets/sanity_2.tres")
const sanity_3 = preload("res://assets/sanity_3.tres")
const sanity_4 = preload("res://assets/sanity_4.tres")
const sanity_5 = preload("res://assets/sanity_5.tres")

# textures[0] = full state
const textures = [sanity_5,sanity_4,sanity_3,sanity_2,sanity_1,sanity_0]

@onready var meter = $CanvasGroup/VBoxContainer/Meter
@onready var timer = $Timer


var max_sanity = 0
var sanity = 0;


func _ready():
	for i in range(sanity_levels):
		var ui = TextureRect.new()
		ui.custom_minimum_size = Vector2(32,32)
		ui.texture = sanity_5
		ui.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		
		meter.add_child(ui)
	
	max_sanity = sanity_levels * 5


func start():
	sanity = max_sanity
	timer.start(sanity_drain_rate)
	_update_ui()


func stop():
	timer.stop()


func _on_timer_timeout():
	sanity -= 1
	
	if sanity <= 0:
		out_of_sanity.emit()
		timer.stop()
	elif sanity <= alert_at * 5:
		alert.emit()
	
	_update_ui()


func _update_ui():
	for i in range(sanity_levels):
		var ui = meter.get_child(i) as TextureRect
		var reversed_i = (sanity_levels - 1) - i
		var icon_sanity = clamp(sanity - (reversed_i * 5), 0, 5)
		var index = 5 - icon_sanity
		
		ui.texture = textures[index]
