extends HBoxContainer
class_name NewJobOptionUI


@export var job: PrintJob

@onready var item_ui = $Item
@onready var print_time = $Control/PrintTime
@onready var num_of_items = $Control/NumOfItems
@onready var reward = $Control/Reward


func _ready():
	print_time.text = str(job.get_total_time())
	num_of_items.text = str(job.items.size())
	reward.text = str(job.reward)
	item_ui.texture = job.item_type
