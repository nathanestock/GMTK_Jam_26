extends Node2D
class_name ThreeDPrinter

const print_item_action_ui = preload("res://ui/print_item_action_ui.tscn")

@export var tier: ThreeDPrinterTier

@onready var sprite = $Sprite2D
@onready var idle_menu = $IdleMenuUI
@onready var move_btn = $IdleMenuUI/Button
@onready var print_items_list = $IdleMenuUI/PrintItems
@onready var countdown = $Countdown
@onready var print_done_ui = $PrintDoneActionUI


enum State { IDLE, PRINTING, DONE }

var state: State = State.IDLE
var printing_items: Array[PrintItem] = []
var player: Player = null
var slot: PrinterTableSlot = null


func _ready():
	sprite.texture = tier.texture


func _on_area_2d_body_entered(body):
	if body is Player:
		player = body 
		match(state):
			State.IDLE:
				_open_idle_menu()
			State.DONE:
				print_done_ui.show_actions()


func _on_area_2d_body_exited(body):
	if body is Player:
		player = null
		if state == State.IDLE:
			_close_idle_menu()
		if state == State.DONE:
			print_done_ui.hide_actions()


func _open_idle_menu():
	if player.carrying:
		move_btn.hide()
	else:
		move_btn.show()
	
	var open_jobs = JobManager.get_open_jobs()
	
	for job in open_jobs:
		var item_ui = print_item_action_ui.instantiate()
		item_ui.job = job
		item_ui.max_items = tier.max_items
		item_ui.print.connect(_on_print_items)
		
		print_items_list.add_child(item_ui)
	
	idle_menu.show()


func _close_idle_menu():
	for item in print_items_list.get_children():
		item.queue_free()
	
	idle_menu.hide()


func _on_print_items(items: Array[PrintItem]):
	printing_items = items
	_set_state(State.PRINTING)
	var print_time = items.map(func (i): return i.print_time).max()
	countdown.start(print_time)
	countdown.show()
	JobManager.on_player_print_items(printing_items)
	_close_idle_menu()


func _set_state(_state: State):
	state = _state


func _on_print_done():
	_set_state(State.DONE)
	countdown.hide()
	print(printing_items)
	print_done_ui.show_items(printing_items)


func _on_player_pickup():
	JobManager.on_player_picked_up_items(printing_items)
	_set_state(State.IDLE)


func _on_move_button_pressed():
	if player:
		player.on_move_printer(self)
