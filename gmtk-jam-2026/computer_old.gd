extends Node2D

const new_print_job = preload("res://ui/new_print_job_ui.tscn")

@export var player: Player = null

@onready var new_jobs = $NewJobs
@onready var area2d = $Area2D

func _ready():
	for job in JobManager.new_jobs:
		_on_new_job(job)
	
	JobManager.new_job.connect(_on_new_job)


func _on_new_job(job: PrintJob):
	var new_job = new_print_job.instantiate()
	new_job.job = job
	area2d.body_entered.connect(new_job.show_actions)
	area2d.body_exited.connect(new_job.hide_actions)
	
	new_job.accepted.connect(_on_job_accepted)
	new_job.expired.connect(JobManager.on_new_job_expired)
	
	new_jobs.add_child(new_job)


func _on_job_accepted(node: NewPrintJobUI):
	JobManager.on_player_accepted_job(node.job)
	node.queue_free()
