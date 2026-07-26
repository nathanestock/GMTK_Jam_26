extends CanvasLayer
class_name JobManagerClass

signal ready_for_job
signal out_of_colors
signal unassigned_items(items: PrintItem)
signal ready_to_ship(job: PrintJob)
signal win_game
signal loss_game
signal reset

const money_to_win = 1000
var zen_mode = false

const print_job_ui = preload("res://ui/print_job_ui.tscn")
const item_circle = preload("res://assets/item_circle.tres")
const item_cross = preload("res://assets/item_cross.tres")
const item_hourglass = preload("res://assets/item_hourglass.tres")
const item_maze = preload("res://assets/item_maze.tres")
const item_plug = preload("res://assets/item_plug.tres")
const item_pyramid = preload("res://assets/item_pyramid.tres")
const item_star = preload("res://assets/item_star.tres")
const item_top = preload("res://assets/item_top.tres")


@onready var play_ui = $PlayGame
@onready var win_ui = $YouWin
@onready var list_hbox = $JobListUI
@onready var money_ui = $MoneyCounterUI
@onready var sanity_ui = $Sanity
@onready var sounds = $SoundEffects
@onready var pet_cat_alert = $PetCatAlert
@onready var lose_ui = $YouLose


var jobs: Array[PrintJob] = []
var available_colors: Array[Color] = [Color("a9def9"), Color("fcf6bd"), Color("ff99c8"), Color("d0f4de"), Color("e4c1f9")]
var available_item_types = [item_circle, item_cross, item_hourglass, item_maze, item_plug, item_pyramid, item_star, item_top]

func _ready():
	play_ui.show()
	win_ui.hide()
	list_hbox.hide()
	money_ui.hide()
	sanity_ui.hide()
	pet_cat_alert.hide()
	lose_ui.hide()
	
	ready_for_job.connect(func (): print("Ready For Job"))
	unassigned_items.connect(func (items): print("Unassigned Items: {items}".format({ "items": items })))
	ready_to_ship.connect(func (job): print("Ready To Ship: {job}".format({ "job": job })))
	out_of_colors.connect(func (): print("Out Of Colors"))
	win_game.connect(_on_win_game)
	sanity_ui.out_of_sanity.connect(_on_lose_game)
	reset.connect(_reset)


func on_play_game():
	print("Play")
	
	play_ui.hide()
	win_ui.hide()
	
	list_hbox.show()
	money_ui.show()
	money_ui.set_money(0)
	money_ui.set_total(money_to_win)
	sanity_ui.show()
	sanity_ui.start()
	ready_for_job.emit()


func _on_win_game():
	print("You win!")
	win_ui.show()
	
	list_hbox.hide()
	money_ui.hide()
	sanity_ui.hide()
	sanity_ui.stop()
	pet_cat_alert.hide()


func _on_lose_game():
	print("You lose!")
	lose_ui.show()
	
	list_hbox.hide()
	money_ui.hide()
	sanity_ui.hide()
	pet_cat_alert.hide()
	
	loss_game.emit()


func on_keep_playing():
	print("Keep playing")
	win_ui.hide()
	
	zen_mode = true
	money_ui.set_zen_mode()
	
	list_hbox.show()
	money_ui.show()
	sanity_ui.show()
	sanity_ui.start()
	pet_cat_alert.hide()


func on_quit():
	print("Quit")
	play_ui.show()
	
	win_ui.hide()
	lose_ui.hide()
	list_hbox.hide()
	money_ui.hide()
	
	reset.emit()


func create_new_jobs() -> Array[PrintJob]:
	var item_types = _get_available_item_types().duplicate()
	item_types.shuffle()
	
	var new_jobs: Array[PrintJob] = []
	
	var item_count_pools = [
		[1, 1, 1, 1, 2, 2, 3],       # Job 1: Mostly 1-2 items, 3 is rare
		[1, 2, 2, 2, 3, 3, 4],       # Job 2: Mostly 2-3 items, 1 or 4 is rare
		[2, 3, 3, 3, 4, 4, 4]        # Job 3: Mostly 3-4 items, 2 is rare
	]
	
	var reward_pools = [
		[15, 15, 15, 20, 20, 25],    # Job 1: Avg ~18
		[20, 20, 25, 25, 30, 30],    # Job 2: Avg ~25
		[25, 30, 30, 35, 35, 40]     # Job 3: Avg ~32.5
	]
	
	var print_time_pools = [
		[5, 5, 5, 10, 10, 15, 20],   		# Job 1: Mostly 5-10 seconds, rare 15, 20
		[5, 10, 10, 15, 15, 20, 20, 25],    # Job 2: Mostly 10-20 seconds, rare 5, 25
		[10, 20, 20, 20, 25, 25, 30] 		# Job 3: Mostly 20-25 seconds, rare 10, 30
	]
	
	var job_costs = [0, 5, 10]
	
	for j in range(3):
		var job = PrintJob.new()
		
		job.cost = job_costs[j]
		job.reward = reward_pools[j].pick_random()
		
		var num_of_items = item_count_pools[j].pick_random()
		var print_time = print_time_pools[j].pick_random()
		
		for i in range(num_of_items):
			var item = PrintItem.new()
			item.job = job
			item.print_time = print_time
			job.items.append(item)
		
		job.duration = print_time * (num_of_items + 2)
		
		job.item_type = item_types.pop_front()
		new_jobs.append(job)
	
	return new_jobs


func on_player_accepted_job(job: PrintJob) -> bool:
	if not money_ui.remove_money(job.cost):
		return false
	
	jobs.append(job)
	sounds.play_accept_job()
	
	_render_jobs_ui()
	
	unassigned_items.emit(job.items)
	
	return true


func on_player_printing_items(items: Array[PrintItem]):
	print("Printing: {items}".format({ "items": items }))
	sounds.play_printer_started()
	
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
		item.set_is_picked_up()
		
	var jobIndex = jobs.find_custom(func (j): return j.items.any(func (i): return items.has(i)))
	var job = jobs[jobIndex]
	
	if job.is_ready_to_ship():
		ready_to_ship.emit(job)
		sounds.play_ready_to_ship()
	
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
	sounds.play_money_increase()
	
	if not zen_mode and money_ui.money >= money_to_win:
		win_game.emit()
		return
	
	if jobs.all(func (j): return j.get_unassigned_items().size() == 0):
		ready_for_job.emit()
	
	_render_jobs_ui()


func get_next_color() -> Color:
	var available = available_colors.filter(func (c): return not jobs.map(func (j): return j.color).has(c))
	
	if available.size() > 0:
		return available[0]
	
	return Color.TRANSPARENT


func _get_available_item_types():
	return available_item_types.filter(func (t): return not jobs.map(func (j): return j.item_type).has(t))


func get_unassigned_items() -> Array[PrintItem]:
	for job in jobs:
		var unassigned = job.get_unassigned_items()
		if unassigned.size() > 0:
			return unassigned
	
	return []


func on_printer_finished():
	_render_jobs_ui()


func get_money() -> int:
	return money_ui.money


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


func _on_sanity_alert():
	pet_cat_alert.show()


func on_pet_cat():
	if win_ui.visible or lose_ui.visible or play_ui.visible:
		return
	
	pet_cat_alert.hide()
	sanity_ui.start()


func _reset():
	jobs = []
	for child in list_hbox.get_children():
		child.queue_free()
	
	play_ui.show()
	win_ui.hide()
	list_hbox.hide()
	money_ui.hide()
	sanity_ui.hide()
	pet_cat_alert.hide()
	lose_ui.hide()
	
	zen_mode = false
