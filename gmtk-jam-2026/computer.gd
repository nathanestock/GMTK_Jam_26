extends Node2D


@onready var player_control = $PlayerControl
@onready var job_list = $PlayerControl/VBoxContainer/Player/ChooseJobPanel/VBoxContainer/ItemList
@onready var countdown = $PlayerControl/VBoxContainer/Static/PanelContainer/VBoxContainer/Countdown
@onready var job_panel = $PlayerControl/VBoxContainer/Player/ChooseJobPanel
@onready var pending_job_alert = $PlayerControl/VBoxContainer/Player/PendingJobAlert
@onready var no_colors_alert = $PlayerControl/VBoxContainer/Player/NoColorsAlert


func _ready():
	_update_job_list()
	countdown.timeout.connect(_update_job_list)
	
	player_control.select_up.connect(_select_up)
	player_control.select_down.connect(_select_down)
	player_control.accept.connect(_accept)
	
	JobManager.ready_for_job.connect(_on_ready_for_job)


func _create_new_job() -> PrintJob:
	var job = PrintJob.new()
	job.duration = 30
	job.reward = 20
	
	for i in randi_range(1, 2):
		var item = PrintItem.new()
		item.print_time = 5
		item.material = 10
		item.color = job.color
		job.items.append(item)
	
	return job


func _update_job_list():
	countdown.start(30)
	job_list.clear()
	
	for i in range(3):
		var job = _create_new_job()
		var list_item_str = "I: {i}, D: {d}, R: {r}".format({ "i": job.items.size(), "d": job.duration, "r": job.reward })
		
		job_list.add_item(list_item_str)
		job_list.set_item_metadata(i, job)
	
	job_list.select(0)


func _select_up():
	if not job_panel.visible:
		return
	
	var index = job_list.get_selected_items()[0]
	job_list.select(max(0, index - 1))


func _select_down():
	if not job_panel.visible:
		return
	
	var index = job_list.get_selected_items()[0]
	job_list.select(min(job_list.item_count-1, index + 1))


func _accept():
	if not job_panel.visible:
		return
	
	var index = job_list.get_selected_items()[0]
	var job = job_list.get_item_metadata(index)
	
	job_panel.hide()
	pending_job_alert.show()
	
	job.color = Color.RED
	
	JobManager.on_player_accepted_job(job)


func _on_ready_for_job():
	pending_job_alert.hide()
	
	# TODO: handle no colors alert
	
	job_panel.show()
