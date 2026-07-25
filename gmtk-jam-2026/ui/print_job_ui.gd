extends PanelContainer
class_name PrintJobUI

const item_required = preload("res://assets/item_required.tres")
const item_finished = preload("res://assets/item_completed.tres")
const item_printing_0 = preload("res://assets/item_printing_0.tres")
const item_printing_1 = preload("res://assets/item_printing_1.tres")
const item_printing_2 = preload("res://assets/item_printing_2.tres")
const item_printing_3 = preload("res://assets/item_printing_3.tres")

@export var job: PrintJob

@onready var countdown = $VBoxContainer/Countdown
@onready var items_list = $VBoxContainer/ItemListUI
@onready var reward_label = $VBoxContainer/RewardLabel

var completed_items: Array[PrintItem] = []

func _ready():
	countdown.start(job.duration)
	
	for item in job.items:
		var item_ui = TextureRect.new()
		item_ui.texture = item_required
		item_ui.custom_minimum_size = Vector2(32,32)
		
		items_list.add_child(item_ui)
	
	reward_label.text = "+ $%d" % job.reward
	
	self_modulate = job.color
	items_list.modulate = job.color
	reward_label.modulate = job.color


func _on_countdown_timeout():
	var timer = Timer.new()
	
	timer.autostart = true
	timer.timeout.connect(func ():
		job.reward -= 5
		
		if job.reward <= 0:
			job.reward = 0
			
			timer.queue_free()
		
		reward_label.text = "+ $%d" % job.reward
	)
	
	add_child(timer)


func update_items():
	var i = 0
	for item in job.items:
		var item_ui = items_list.get_child(i) as TextureRect
		if item.is_picked_up():
			item_ui.texture = job.item_type
		elif item.is_completed():
			item_ui.texture = item_finished
			var timer = item_ui.find_child("Timer")
			if timer:
				timer.queue_free()
		elif item.is_printing():
			if item_ui.find_child("Timer"):
				pass
			else:
				item_ui.texture = item_printing_0
				
				var timer = Timer.new()
				timer.autostart = true
				timer.wait_time = 0.5
				timer.timeout.connect(func (): _next_item_printing_ui(item_ui))
				
				item_ui.add_child(timer)
		
		i += 1


func _next_item_printing_ui(item_ui: TextureRect):
	match(item_ui.texture):
		item_printing_0:
			item_ui.texture = item_printing_1
		item_printing_1:
			item_ui.texture = item_printing_2
		item_printing_2:
			item_ui.texture = item_printing_3
		item_printing_3:
			item_ui.texture = item_printing_0
