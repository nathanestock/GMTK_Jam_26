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

var printer: ThreeDPrinter


func _ready():
	if tier:
		printer = printer_scene.instantiate()
		printer.tier = tier
		printer.position = printer_position
		
		add_child(printer)
		
		move_action.show()


func _on_player_control_accept():
	if print_action.visible:
		# print items
		pass
	elif pickup_action.visible:
		# pickup items
		pass


func _on_player_control_select_up():
	# PlayerControl.select_up [W] is used for move/place/swap
	if move_action.visible:
		_on_move_printer()
	elif place_action.visible:
		_on_place_printer()
	elif swap_action.visible:
		_on_swap_printer()


func _on_items_to_print(items: Array[PrintItem]):
	if printer and printer.is_idle():
		move_action.hide()
		print_action.show()
		# set items to print UI


func _on_player_control_player_entered(player: Player):
	if player.carrying:
		move_action.hide()
		if not printer:
			place_action.show()
		elif printer.is_idle():
			swap_action.show()
	elif printer:
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
