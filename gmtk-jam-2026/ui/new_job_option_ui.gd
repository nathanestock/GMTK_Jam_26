extends HBoxContainer
class_name NewJobOptionUI


@export var job: PrintJob
@export var can_afford: bool = true

@onready var job_option_ui = $Control/JobOption
@onready var item_ui = $Item
@onready var print_time = $Control/PrintTime
@onready var num_of_items = $Control/NumOfItems
@onready var cost = $Control/Cost
@onready var reward = $Control/Reward
@onready var need_money = $Control/NeedMoneyAlert


func _ready():
	print_time.text = str(job.get_total_time())
	num_of_items.text = str(job.items.size())
	cost.text = str(job.cost)
	reward.text = str(job.reward)
	item_ui.texture = job.item_type


func _draw():
	if not can_afford:
		job_option_ui.hide()
		item_ui.modulate.a = 0.2
		print_time.hide()
		num_of_items.hide()
		cost.hide()
		reward.hide()
		
		need_money.show()
	else:
		job_option_ui.show()
		item_ui.modulate.a = 1.0
		print_time.show()
		num_of_items.show()
		cost.show()
		reward.show()
		
		need_money.hide()
