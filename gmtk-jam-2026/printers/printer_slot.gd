extends Node2D
class_name PrinterSlot

const printer_scene = preload("res://printers/3d_printer.tscn")
const printer_position = Vector2(-2, -96)

@export var tier: ThreeDPrinterTier

@onready var player_control = $PlayerControl
@onready var print_action = $PlayerControl/VBoxContainer/Player/PrintAction
@onready var move_action = $PlayerControl/VBoxContainer/Player/MoveAction
@onready var place_action = $PlayerControl/VBoxContainer/Player/PlaceAction
@onready var swap_action = $PlayerControl/VBoxContainer/Player/SwapAction
@onready var collect_action = $PlayerControl/VBoxContainer/Player/CollectAction
@onready var printing_countdown = $PlayerControl/VBoxContainer/Static/Countdown
@onready var finished_alert = $PlayerControl/VBoxContainer/Static/FinishedAlert

var printer: ThreeDPrinter


func _ready():
	JobManager.unassigned_items.connect(_on_unassigned_items)
	
	print_action.hide()
	move_action.hide()
	place_action.hide()
	swap_action.hide()
	collect_action.hide()
	printing_countdown.hide()
	finished_alert.hide()
	
	if tier:
		printer = printer_scene.instantiate()
		printer.tier = tier
		printer.position = printer_position
		
		_set_printer(printer)
		
		add_child(printer)
		
		move_action.show()


func _on_player_control_accept():
	if print_action.visible:
		var print_items = print_action.items
		printer.start_printing(printing_countdown, print_items)
		printer.finished_printing.connect(_on_finished_printing)
		
		JobManager.on_player_printing_items(print_items)
		
		print_action.hide()
		printing_countdown.show()
	elif collect_action.visible:
		printer.on_picked_up_items()
		
		JobManager.on_player_picking_up_items(finished_alert.items)
		
		_on_unassigned_items(JobManager.get_unassigned_items())
		
		finished_alert.hide()
		collect_action.hide()


func _on_finished_printing(items: Array[PrintItem]):
	printer.finished_printing.disconnect(_on_finished_printing)
	
	printing_countdown.hide()
		
	for item in items:
		item.set_is_completed()
	
	finished_alert.set_items(printer.printing_items)
	
	JobManager.on_printer_finished()
	
	finished_alert.show()
	collect_action.show()


func _on_player_control_select_up():
	# PlayerControl.select_up [W] is used for move/place/swap
	if move_action.visible or print_action.visible:
		_on_move_printer()
	elif place_action.visible:
		_on_place_printer()
	elif swap_action.visible:
		_on_swap_printer()


func _on_unassigned_items(items: Array[PrintItem]):
	if printer and printer.is_idle():
		if items.size() == 0:
			print_action.hide()
			move_action.show()
			return
		
		var to_print: Array[PrintItem] = []
		
		for item in items:
			to_print.append(item)
			
			if to_print.size() >= printer.tier.max_items:
				print("can_print: {print}, max_items: {d}".format({ "print": to_print, "d": printer.tier.max_items }))
				break
		
		print_action.set_items(to_print)
		
		move_action.hide()
		print_action.show()


func _on_player_control_player_entered(player: Player):
	if player.carrying:
		move_action.hide()
		print_action.hide()
		if not printer:
			place_action.show()
		elif printer.is_idle():
			swap_action.show()
	elif printer:
		if not print_action.visible and printer.is_idle():
			_on_unassigned_items(JobManager.get_unassigned_items())
		place_action.hide()
		swap_action.hide()
	else:
		move_action.hide()
		place_action.hide()
		swap_action.hide()


func _on_move_printer():
	player_control.player.move_printer(printer)
	remove_child(printer)
	_set_printer(null)
	
	print_action.hide()
	move_action.hide()
	place_action.show()


func _on_place_printer():
	_set_printer(player_control.player.carrying)
	player_control.player.place_printer()
	printer.position = printer_position
	
	add_child(printer)
	
	place_action.hide()
	
	_on_unassigned_items(JobManager.get_unassigned_items())


func _on_swap_printer():
	var swap = player_control.player.carrying
	player_control.player.place_printer()
	player_control.player.move_printer(printer)
	
	remove_child(printer)
	
	_set_printer(swap)
	printer.position = printer_position
	
	add_child(printer)
	swap_action.queue_redraw()


func _set_printer(_printer: ThreeDPrinter):
	printer = _printer
	if printer:
		tier = printer.tier
		print_action.tier = tier
		move_action.tier = tier
		place_action.tier = tier
		swap_action.tier = tier
		collect_action.tier = tier
		finished_alert.tier = tier
	else:
		tier = null
		print_action.tier = null
		move_action.tier = null
		place_action.tier = null
		swap_action.tier = null
		collect_action.tier = null
		finished_alert.tier = null
