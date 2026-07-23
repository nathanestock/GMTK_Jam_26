extends Node2D
class_name ThreeDPrinter

const print_item_action_ui = preload("res://ui/print_item_action_ui.tscn")

@export var max_items: int = 1

@onready var print_items_list = $PrintItems
@onready var state_label = $StateLabel
@onready var countdown = $Countdown
@onready var print_done_ui = $PrintDoneActionUI

enum State { IDLE, PRINTING, DONE }

var state: State = State.IDLE
var printing_items: Array[PrintItem] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if body is Player:
		match(state):
			State.IDLE:
				_open_print_items_list()
			State.DONE:
				print_done_ui.show_actions()


func _on_area_2d_body_exited(body):
	if body is Player:
		if state == State.IDLE:
			_close_print_items_list()
		if state == State.DONE:
			print_done_ui.hide_actions()


func _open_print_items_list():
	var open_jobs = JobManager.get_open_jobs()
	
	for job in open_jobs:
		var item_ui = print_item_action_ui.instantiate()
		item_ui.job = job
		item_ui.max_items = max_items
		item_ui.print.connect(_on_print_items)
		
		print_items_list.add_child(item_ui)
	
	print_items_list.show()


func _close_print_items_list():
	for item in print_items_list.get_children():
		item.queue_free()
	print_items_list.hide()


func _on_print_items(items: Array[PrintItem]):
	printing_items = items
	_set_state(State.PRINTING)
	var print_time = items.map(func (i): return i.print_time).max()
	countdown.start(print_time)
	countdown.show()
	JobManager.on_player_print_items(printing_items)
	_close_print_items_list()


func _set_state(_state: State):
	state = _state
	match(state):
		State.IDLE:
			state_label.text = "IDLE"
		State.PRINTING:
			state_label.text = "PRINTING"
		State.DONE:
			state_label.text = "DONE"


func _on_print_done():
	_set_state(State.DONE)
	countdown.hide()
	print_done_ui.show_items(printing_items)


func _on_player_pickup():
	JobManager.on_player_picked_up_items(printing_items)
	_set_state(State.IDLE)
	
