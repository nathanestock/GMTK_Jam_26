extends Node2D
class_name Mailbox

const item_list_ui = preload("res://ui/item_list_ui.tscn")

@onready var ship_action = $PlayerControl/VBoxContainer/Player/ShipAction
@onready var ship_alert = $PlayerControl/VBoxContainer/Static/ReadyToShipAlert
@onready var ship_jobs_list = $PlayerControl/VBoxContainer/Static/ReadyToShipAlert/ReadyToShipJobs


func _ready():
	JobManager.ready_to_ship.connect(_on_ready_to_ship)
	
	ship_action.hide()
	ship_alert.hide()


func _on_ready_to_ship(job: PrintJob):
	var item_list = item_list_ui.instantiate()
	item_list.set_items(job.items)
	ship_jobs_list.add_child(item_list)
	
	ship_alert.show()
	ship_action.show()


func _on_player_control_accept():
	if ship_alert.visible and ship_action.visible:
		JobManager.on_player_shipping_jobs()
		
		for item in ship_jobs_list.get_children():
			item.queue_free()
		
		ship_action.hide()
		ship_alert.hide()
