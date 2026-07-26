extends Node2D
class_name Mailbox

const package = preload("res://assets/package.tres")

@onready var ship_action = $CanvasGroup/PlayerControl/VBoxContainer/Player/ShipAction
@onready var ship_alert = $CanvasGroup/PlayerControl/VBoxContainer/Static/ReadyToShipAlert
@onready var packages_ui = $CanvasGroup/PlayerControl/VBoxContainer/Static/ReadyToShipAlert/Packages


func _ready():
	JobManager.reset.connect(_reset)
	JobManager.ready_to_ship.connect(_on_ready_to_ship)
	
	ship_action.hide()
	ship_alert.hide()


func _on_ready_to_ship(job: PrintJob):
	var package_ui = TextureRect.new()
	package_ui.texture = package
	package_ui.modulate = job.color
	
	packages_ui.add_child(package_ui)
	
	ship_alert.show()
	ship_action.show()


func _on_player_control_accept():
	if ship_alert.visible and ship_action.visible:
		JobManager.on_player_shipping_jobs()
		
		for child in packages_ui.get_children():
			child.queue_free()
		
		ship_action.hide()
		ship_alert.hide()


func _reset():
	for child in packages_ui.get_children():
		child.queue_free()
	
	ship_action.hide()
	ship_alert.hide()
