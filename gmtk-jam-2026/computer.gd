extends Node2D


@onready var player_control = $PlayerControl
@onready var new_jobs_ui = $PlayerControl/VBoxContainer/Player/NewJobsUI
@onready var assign_printers_alert = $PlayerControl/VBoxContainer/Static/CanvasGroup/AssignPrintersAlert
@onready var no_colors_alert = $PlayerControl/VBoxContainer/Static/CanvasGroup/NoColorsAlert
@onready var choose_job_alert = $PlayerControl/VBoxContainer/Static/CanvasGroup/ChooseJob


func _ready():	
	player_control.select_up.connect(new_jobs_ui.select_up)
	player_control.select_down.connect(new_jobs_ui.select_down)
	player_control.accept.connect(_accept)
	
	JobManager.ready_for_job.connect(_on_ready_for_job)
	JobManager.out_of_colors.connect(_on_out_of_colors)
	
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
