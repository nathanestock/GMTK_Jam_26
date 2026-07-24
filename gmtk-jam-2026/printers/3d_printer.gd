extends Node2D
class_name ThreeDPrinter

signal finished_printing(items: Array[PrintItem])

@export var tier: ThreeDPrinterTier

@onready var sprite = $Sprite2D


enum State { IDLE, PRINTING, DONE }

var state: State = State.IDLE
var printing_items: Array[PrintItem] = []
var countdown: Countdown = null


func _ready():
	sprite.texture = tier.texture


func is_idle() -> bool:
	return state == State.IDLE


func start_printing(_countdown: Countdown, items: Array[PrintItem]):
	printing_items = items.duplicate()
	state = State.PRINTING
	
	# Use maximum print time strategy
	var print_time = items.map(func (i): return i.print_time).max()
	
	countdown = _countdown
	countdown.start(print_time)
	countdown.timeout.connect(_on_finished_printing)


func _on_finished_printing():
	countdown.timeout.disconnect(_on_finished_printing)
	finished_printing.emit(printing_items)
	state = State.DONE


func on_picked_up_items():
	printing_items = []
	state = State.IDLE
