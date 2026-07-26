extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 1000.0
const FRICTION = 5000.0

const meow = preload("res://sounds/Meow.mp3")

@export var travel_range: Vector2 # x_min, x_max

@onready var animations = $CanvasGroup2/AnimatedSprite2D
@onready var cat_control = $CanvasGroup/CatControl
@onready var cat_countdown = $CanvasGroup/CatControl/Labels/Static/Countdown
@onready var needs_pet_timer = $NeedsPetTimer
@onready var static_ui = $CanvasGroup/CatControl/Labels/Static
@onready var player_ui = $CanvasGroup/CatControl/Labels/Player
@onready var travel_timer = $TravelTimer
@onready var sleep_timer = $SleepTimer
@onready var sounds = $SoundEffects

var rng = RandomNumberGenerator.new()

enum State { SLEEPING, AWAKE, TRAVELING, NEEDS_PET, ATTACKING }

var state = State.AWAKE
var travel_target: int 

func _ready():	
	cat_control.pet.connect(_pet)
	cat_countdown.timeout.connect(_on_pet_timeout)
	needs_pet_timer.timeout.connect(_needs_pet)
	static_ui.show() # Revert back to hide
	player_ui.hide()
	
	_reset_pet_timer()
	_reset_travel_timer()


func _physics_process(delta):
	match(state):
		State.TRAVELING:
			_traveling(delta)
		State.ATTACKING:
			_attacking()


func _awake():
	state = State.AWAKE
	animations.play("Sit")
	_reset_travel_timer()


func _sleep():
	state = State.SLEEPING
	animations.play("Sleep")
	_reset_sleep_timer()


func _needs_pet():
	return # Require pets later
	
	state = State.NEEDS_PET
	animations.play("Sit")
	
	static_ui.show()
	cat_countdown.start(10)
	needs_pet_timer.stop()


func _traveling(delta):
	var direction = travel_target - position.x
	direction = min(1, direction)
	direction = max(-1, direction)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
		if direction > 0:
			animations.flip_h = true
		elif direction < 0:
			animations.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
	
	if abs(travel_target - position.x) < 10:
		print("Cat arrived to travel target")
		
		if randf() < 0.5:
			_awake()
		else:
			_sleep()


func _attacking():
	state = State.ATTACKING
	animations.play("Attack")


func _pet():
	JobManager.on_pet_cat()
	
	cat_countdown.stop()
	static_ui.hide()
	player_ui.hide()
	
	sounds.stream = meow
	sounds.play()
	
	_reset_pet_timer()


func _on_pet_timeout():
	_attacking()


func _reset_pet_timer():
	needs_pet_timer.start(rng.randi_range(5,10))


func _on_travel_timer_timeout():
	travel_target = randi_range(int(travel_range.x), int(travel_range.y))
	
	print("Travel to: %d" % travel_target)
	
	state = State.TRAVELING
	animations.play("Walk")


func _reset_travel_timer():
	travel_timer.start(rng.randi_range(5,10))
	


func _reset_sleep_timer():
	sleep_timer.start(rng.randi_range(5,10))


func _on_sleep_timer_timeout():
	_awake()
	sounds.stream = meow
	sounds.play()
