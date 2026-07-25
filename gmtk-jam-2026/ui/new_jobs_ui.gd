extends VBoxContainer
class_name NewJobsUI

const option_ui = preload("res://ui/new_job_option_ui.tscn")

@onready var list = $JobsList

var selected: int = 0
var color: Color

func set_jobs(jobs: Array[PrintJob]):	
	for i in list.get_children():
		i.free()
		
	color = JobManager.get_next_color()
	if color == Color.TRANSPARENT:
		return
	
	for job in jobs:
		job.set_color(color)
		var option = option_ui.instantiate()
		option.job = job
		
		list.add_child(option)
	
	select(0)


func select_up():
	if not visible:
		return
	select(max(0, selected - 1))


func select_down():
	if not visible:
		return
	select(min(list.get_child_count() - 1, selected + 1))


func select(index: int):
	selected = index
	for i in range(list.get_child_count()):
		var option = list.get_child(i) as NewJobOptionUI
		if i == index:
			option.modulate = color
		else:
			option.modulate = Color.WHITE
		i += 1


func get_selected() -> PrintJob:
	return list.get_children()[selected].job
