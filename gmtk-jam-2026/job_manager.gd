extends CanvasLayer
class_name JobManagerClass

signal job_completed(PrintJob)

const print_job_ui = preload("res://ui/print_job_ui.tscn")

@onready var list_hbox = $JobListUI
@onready var money_ui = $MoneyCounterUI

var jobs: Array[PrintJob] = []


func _ready():
	money_ui.set_money(20)

func on_player_accepted_job(job: PrintJob):
	jobs.append(job)
	_render_jobs_ui()


func on_player_picked_up_items(items: Array[PrintItem]):
	for item in items:
		item.set_is_completed()
		
	var jobIndex = jobs.find_custom(func (j): return j.items.any(func (i): return items.has(i)))
	var job = jobs[jobIndex]
	if job.is_completed():
		job_completed.emit(job)
	
	_render_jobs_ui()


func get_open_jobs() -> Array[PrintJob]:
	return list_hbox.get_children().map(func (c): return c.job).filter(func (j): return j.is_open())


func on_player_print_items(items: Array[PrintItem]):
	for item in items:
		item.set_is_printing()
	_render_jobs_ui()


func _render_jobs_ui():
	for job in jobs:
		var index = list_hbox.get_children().map(func (ui): return ui.job).find(job)
		if index > -1:
			var ui = list_hbox.get_child(index) as PrintJobUI
			ui.update_items()
		else:
			var new_job_ui = print_job_ui.instantiate()
			new_job_ui.job = job
			list_hbox.add_child(new_job_ui)


func deliver_completed_jobs():
	var completed_jobs = jobs.filter(func (j): return j.is_completed())
	completed_jobs.reverse()
	for job in completed_jobs:
		money_ui.add_money(job.reward)
		
		var index = list_hbox.get_children().map(func (ui): return ui.job).find(job)
		var job_ui = list_hbox.get_child(index)
		job_ui.queue_free()
		jobs.remove_at(index)
