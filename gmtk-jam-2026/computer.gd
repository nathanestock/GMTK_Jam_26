extends Node2D


@onready var player_control = $PlayerControl
@onready var job_list = $PlayerControl/VBoxContainer/Player/ChooseJobPanel/VBoxContainer/ItemList
@onready var countdown = $PlayerControl/VBoxContainer/Static/PanelContainer/VBoxContainer/Countdown
@onready var job_panel = $PlayerControl/VBoxContainer/Player/ChooseJobPanel
@onready var pending_job_alert = $PlayerControl/VBoxContainer/Player/PendingJobAlert
@onready var no_colors_alert = $PlayerControl/VBoxContainer/Player/NoColorsAlert
@onready var no_jobs_alert = $PlayerControl/VBoxContainer/Player/NoJobsAlert


func _ready():
	countdown.timeout.connect(_update_job_list)
	
	player_control.select_up.connect(_select_up)
	player_control.select_down.connect(_select_down)
	player_control.accept.connect(_accept)
	
	JobManager.ready_for_job.connect(_on_ready_for_job)
	JobManager.out_of_colors.connect(_on_out_of_colors)
	
	job_panel.hide()
	pending_job_alert.hide()
	no_colors_alert.hide()
	no_jobs_alert.hide()
	
	_update_job_list()


func _create_new_job() -> PrintJob:
	var job = PrintJob.new()
	job.duration = 30
	job.reward = 20
	
	for i in randi_range(1, 4):
		var item = PrintItem.new()
		item.job = job
		item.print_time = 5
		item.material = 10
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
	
	no_jobs_alert.hide()
	job_panel.show()


func _select_up():
	if not job_panel.visible or job_list.item_count == 0:
		return
	
	var index = job_list.get_selected_items()[0]
	job_list.select(max(0, index - 1))


func _select_down():
	if not job_panel.visible or job_list.item_count == 0:
		return
	
	var index = job_list.get_selected_items()[0]
	job_list.select(min(job_list.item_count-1, index + 1))


func _accept():
	if not job_panel.visible:
		return
	
	var index = job_list.get_selected_items()[0]
	var job = job_list.get_item_metadata(index)
	
	job_list.remove_item(index)
	
	if job_list.item_count > 0:
		job_list.select(0)
	
	job_panel.hide()
	pending_job_alert.show()
	
	job.set_color(JobManager.get_next_color())
	
	JobManager.on_player_accepted_job(job)


func _on_ready_for_job():
	pending_job_alert.hide()
	no_colors_alert.hide()
	
	if job_list.item_count == 0:
		no_jobs_alert.show()
	else:
		job_panel.show()


func _on_out_of_colors():
	pending_job_alert.hide()
	no_colors_alert.show()
