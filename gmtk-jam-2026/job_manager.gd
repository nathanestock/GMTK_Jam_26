extends CanvasLayer
class_name JobManagerClass

signal ready_for_job
signal out_of_colors
signal unassigned_items(items: PrintItem)
signal ready_to_ship(job: PrintJob)

const print_job_ui = preload("res://ui/print_job_ui.tscn")

@onready var list_hbox = $JobListUI
@onready var money_ui = $MoneyCounterUI

var jobs: Array[PrintJob] = []
var available_colors: Array[Color] = [Color.BLUE, Color.RED, Color.GREEN]

func _ready():
	money_ui.set_money(20)
	
	ready_for_job.connect(func (): print("Ready For Job"))
	unassigned_items.connect(func (items): print("Unassigned Items: {items}".format({ "items": items })))
	ready_to_ship.connect(func (job): print("Ready To Ship: {job}".format({ "job": job })))
	out_of_colors.connect(func (): print("Out Of Colors"))
	
	ready_for_job.emit()


func on_player_accepted_job(job: PrintJob):
	jobs.append(job)
	
	_render_jobs_ui()
	
	unassigned_items.emit(job.items)


func on_player_printing_items(items: Array[PrintItem]):
	print("Printing: {items}".format({ "items": items }))
	var job = items[0].job
	
	for item in items:
		item.set_is_printing()
	
	_render_jobs_ui()
	
	var unassigned = job.get_unassigned_items()
	unassigned_items.emit(unassigned)
	
	if unassigned.size() == 0:
		if _is_out_of_colors():
			out_of_colors.emit()
		else:
			ready_for_job.emit()


func on_player_picking_up_items(items: Array[PrintItem]):
	for item in items:
		item.set_is_completed()
		
	var jobIndex = jobs.find_custom(func (j): return j.items.any(func (i): return items.has(i)))
	var job = jobs[jobIndex]
	if job.is_ready_to_ship():
		ready_to_ship.emit(job)
	
	_render_jobs_ui()


func on_player_shipping_jobs():
	var completed_jobs = jobs.filter(func (j): return j.is_ready_to_ship())
	completed_jobs.reverse()
	
	var total_reward = 0
	for job in completed_jobs:
		total_reward += job.reward
		
		var index = list_hbox.get_children().map(func (ui): return ui.job).find(job)
		var job_ui = list_hbox.get_child(index)
		job_ui.queue_free()
		jobs.remove_at(index)
	
	money_ui.add_money(total_reward)
	
	ready_for_job.emit()
	
	_render_jobs_ui()


func get_next_color() -> Color:
	var available = available_colors.filter(func (c): return not jobs.map(func (j): return j.color).has(c))
	return available[0]


func get_unassigned_items() -> Array[PrintItem]:
	for job in jobs:
		var unassigned = job.get_unassigned_items()
		if unassigned.size() > 0:
			return unassigned
	
	return []


func _is_out_of_colors() -> bool:
	var available = available_colors.filter(func (c): return not jobs.map(func (j): return j.color).has(c))
	
	return available.size() == 0


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
