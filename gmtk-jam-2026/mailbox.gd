extends Node2D
class_name Mailbox


@onready var deliver_jobs_ui = $ReadyToDeliverJobs
@onready var completed_jobs_list = $ReadyToDeliverJobs/VBoxContainer/CompletedJobList
@onready var btn = $ReadyToDeliverJobs/VBoxContainer/Button


# Called when the node enters the scene tree for the first time.
func _ready():
	JobManager.job_completed.connect(_on_job_completed)


func _on_area_2d_body_entered(body):
	if body is Player:
		btn.show()


func _on_area_2d_body_exited(body):
	if body is Player:
		btn.hide()


func _on_job_completed(job: PrintJob):
	var job_item_list = HBoxContainer.new()
	for item in job.items:
		var rect = ColorRect.new()
		rect.custom_minimum_size = Vector2(24,24)
		rect.color = item.color
		job_item_list.add_child(rect)
	
	completed_jobs_list.add_child(job_item_list)
	deliver_jobs_ui.show()


func _on_button_pressed():
	JobManager.deliver_completed_jobs()
	deliver_jobs_ui.hide()
	for hbox in completed_jobs_list.get_children():
		hbox.queue_free()
