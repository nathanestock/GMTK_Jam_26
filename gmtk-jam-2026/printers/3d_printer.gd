extends CanvasGroup
class_name ThreeDPrinter

signal finished_printing(items: Array[PrintItem])

@export var tier: ThreeDPrinterTier

@onready var sprite = $AnimatedSprite2D
@onready var printer_sound = $PrinterSound
@onready var finished_sound = $FinishedSound
@onready var collected_sound = $CollectedSound


enum State { IDLE, PRINTING, DONE }

var state: State = State.IDLE
var printing_items: Array[PrintItem] = []
var countdown: Countdown = null


func _ready():
	JobManager.reset.connect(_reset)
	sprite.sprite_frames = tier.sprite_frames
	sprite.frame = tier.idle_frame
	
	# offset for tier 3
	if tier.max_items == 4:
		sprite.position.x = 0
	else:
		sprite.position.x = 4


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
	
	printer_sound.play(0)
	
	sprite.frame = 0
	sprite.play("default")


func _on_finished_printing():
	countdown.timeout.disconnect(_on_finished_printing)
	finished_printing.emit(printing_items)
	state = State.DONE
	
	printer_sound.stop()
	finished_sound.play()
	
	sprite.stop()
	sprite.frame = tier.idle_frame


func on_picked_up_items():
	printing_items = []
	state = State.IDLE
	
	collected_sound.play()


func _reset():
	printing_items = []
	if countdown:
		countdown.stop()
		if countdown.timeout.is_connected(_on_finished_printing):
			countdown.timeout.disconnect(_on_finished_printing)
	printer_sound.stop()
	state = State.IDLE
	
	sprite.stop()
	sprite.frame = tier.idle_frame
