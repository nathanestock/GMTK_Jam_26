extends CharacterBody2D


@onready var animations = $AnimatedSprite2D
@onready var cat_control = $CatControl
@onready var cat_countdown = $CatControl/Labels/Static/Countdown
@onready var cat_timer = $Timer
@onready var static_ui = $CatControl/Labels/Static
@onready var player_ui = $CatControl/Labels/Player

var rng = RandomNumberGenerator.new()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():	
	cat_control.pet.connect(_pet)
	cat_countdown.timeout.connect(_attack)
	static_ui.hide()
	player_ui.hide()
	_sleep()
	
	

func _pet():
	# increase sanity
	
	# stop countdown
	cat_countdown.stop()
	static_ui.hide()
	player_ui.hide()
	# start hidden timer
	_sleep()
	

func _sleep():
	#set animation to sleep
	animations.play("Sleep")
	#start random timer
	var sleepTime = rng.randi_range(10,30)
	cat_timer.start(sleepTime)


func _on_timer_timeout():
	cat_timer.stop()
	#wake up
	animations.play("Sit")
	#start countdown
	static_ui.show()
	cat_countdown.start(10)

func _attack():
	animations.play("Attack")



	
