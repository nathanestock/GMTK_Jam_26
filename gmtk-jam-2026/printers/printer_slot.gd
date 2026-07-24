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
@onready var pickup_action = $PlayerControl/VBoxContainer/Player/PickupAction
@onready var print_item_list = $PlayerControl/VBoxContainer/Player/PrintAction/VBoxContainer/ItemListUI
@onready var printing_countdown = $PlayerControl/VBoxContainer/Static/PrintingCountdown/Countdown
@onready var printing_countdown_ui = $PlayerControl/VBoxContainer/Static/PrintingCountdown
@onready var print_finished_ui = $PlayerControl/VBoxContainer/Static/PrintFinishedAlert
@onready var print_finished_list = $PlayerControl/VBoxContainer/Static/PrintFinishedAlert/ItemListUI

var printer: ThreeDPrinter


func _ready():
	JobManager.unassigned_items.connect(_on_unassigned_items)
	
	print_action.hide()
	move_action.hide()
	place_action.hide()
	swap_action.hide()
	pickup_action.hide()
	printing_countdown_ui.hide()
	
	if tier:
		printer = printer_scene.instantiate()
		printer.tier = tier
		printer.position = printer_position
		
		add_child(printer)
		
		move_action.show()


func _on_player_control_accept():
	if print_action.visible:
		var print_items = print_item_list.items
		printer.start_printing(printing_countdown, print_items)
		printer.finished_printing.connect(_on_finished_printing)
		
		JobManager.on_player_printing_items(print_items)
		
		print_action.hide()
		printing_countdown_ui.show()
	elif pickup_action.visible:
		printer.on_picked_up_items()
		
		JobManager.on_player_picking_up_items(print_finished_list.items)
		
		_on_unassigned_items(JobManager.get_unassigned_items())
		
		print_finished_ui.hide()
		pickup_action.hide()


func _on_finished_printing(items: Array[PrintItem]):
	printer.finished_printing.disconnect(_on_finished_printing)
	
	printing_countdown_ui.hide()
	
	print_finished_list.clear()
		
	for item in items:
		print_finished_list.add_item(item)
	
	print_finished_ui.show()
	
	pickup_action.show()


func _on_player_control_select_up():
	# PlayerControl.select_up [W] is used for move/place/swap
	if move_action.visible:
		_on_move_printer()
	elif place_action.visible:
		_on_place_printer()
	elif swap_action.visible:
		_on_swap_printer()


func _on_unassigned_items(items: Array[PrintItem]):
	if printer and printer.is_idle():
		if items.size() == 0:
			print_action.hide()
			return
		
		move_action.hide()
		
		print_item_list.clear()
		
		for item in items:
			print_item_list.add_item(item)
			
			if print_item_list.items.size() >= printer.tier.max_items:
				print("can_print: {print}, max_items: {d}".format({ "print": print_item_list.items, "d": printer.tier.max_items }))
				break
		
		print_action.show()


func _on_player_control_player_entered(player: Player):
	if player.carrying:
		move_action.hide()
		if not printer:
			place_action.show()
		elif printer.is_idle():
			swap_action.show()
	elif printer:
		if not print_action.visible and printer.is_idle():
			move_action.show()
		place_action.hide()
		swap_action.hide()
	else:
		move_action.hide()
		place_action.hide()
		swap_action.hide()


func _on_move_printer():
	player_control.player.move_printer(printer)
	remove_child(printer)
	printer = null
	
	move_action.hide()
	place_action.show()


func _on_place_printer():
	printer = player_control.player.carrying
	player_control.player.place_printer()
	printer.position = printer_position
	
	add_child(printer)
	
	place_action.hide()
	move_action.show()


func _on_swap_printer():
	var swap = player_control.player.carrying
	player_control.player.place_printer()
	player_control.player.move_printer(printer)
	
	remove_child(printer)
	
	printer = swap
	printer.position = printer_position
	
	add_child(printer)
