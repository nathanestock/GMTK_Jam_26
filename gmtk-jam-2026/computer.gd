extends Node2D


@onready var player_control = $PlayerControl
@onready var new_jobs_ui = $PlayerControl/VBoxContainer/Player/NewJobsUI
@onready var assign_printers_alert = $PlayerControl/VBoxContainer/Static/CanvasGroup/AssignPrintersAlert
@onready var no_colors_alert = $PlayerControl/VBoxContainer/Static/CanvasGroup/NoColorsAlert
@onready var choose_job_alert = $PlayerControl/VBoxContainer/Static/CanvasGroup/ChooseJob
@onready var unassigned_items_ui = $PlayerControl/VBoxContainer/Static/CanvasGroup/AssignPrintersAlert/HBoxContainer


func _ready():	
	player_control.select_up.connect(new_jobs_ui.select_up)
	player_control.select_down.connect(new_jobs_ui.select_down)
	player_control.accept.connect(_accept)
	
	JobManager.ready_for_job.connect(_on_ready_for_job)
	JobManager.out_of_colors.connect(_on_out_of_colors)
	JobManager.unassigned_items.connect(_render_unassigned_items)
	
	new_jobs_ui.hide()
	assign_printers_alert.hide()
	no_colors_alert.hide()
	choose_job_alert.hide()
	
	_update_job_list()


func _update_job_list():
	var new_jobs = JobManager.create_new_jobs()
	
	new_jobs_ui.set_jobs(new_jobs)
	new_jobs_ui.show()
	choose_job_alert.show()


func _accept():
	if not new_jobs_ui.visible:
		return
	
	var job = new_jobs_ui.get_selected()
	
	if not JobManager.on_player_accepted_job(job):
		return
	
	new_jobs_ui.hide()
	choose_job_alert.hide()
	assign_printers_alert.show()


func _on_ready_for_job():
	assign_printers_alert.hide()
	no_colors_alert.hide()
	
	_update_job_list()


func _on_out_of_colors():
	assign_printers_alert.hide()
	no_colors_alert.show()


func _render_unassigned_items(items: Array[PrintItem]):
	for c in unassigned_items_ui.get_children():
		c.queue_free()
	
	if items.size() == 0:
		return
	
	var item_type = items[0].job.item_type
	var color = items[0].job.color
	
	for item in items:
		var ui = TextureRect.new()
		ui.texture = item_type
		ui.modulate = color
		
		unassigned_items_ui.add_child(ui)
