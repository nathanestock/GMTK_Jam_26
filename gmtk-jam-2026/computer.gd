extends Node2D

const new_print_job = preload("res://ui/new_print_job_ui.tscn")
const basic_job = preload("res://jobs/basic_job.tres")
const big_job = preload("res://jobs/big_job.tres")

@export var player: Player = null

@onready var new_jobs = $NewJobs
@onready var area2d = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	_new_job(basic_job)
	_new_job(big_job)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var jobs = new_jobs.get_children()
	if jobs.size() == 0:
		_new_job(basic_job)

func _new_job(job: PrintJob):
	var new_job = new_print_job.instantiate()
	new_job.job = job
	new_job.job.set_item_colors()
	area2d.body_entered.connect(new_job.show_actions)
	area2d.body_exited.connect(new_job.hide_actions)
	new_job.accepted.connect(_on_job_accepted)
	
	new_jobs.add_child(new_job)

func _on_job_accepted(node: NewPrintJobUI):
	JobManager.on_player_accepted_job(node.job)
	node.queue_free()
