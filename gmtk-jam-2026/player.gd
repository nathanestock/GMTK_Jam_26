extends CharacterBody2D
class_name Player

const SPEED = 300.0

@onready var sprite = $Sprite2D
@onready var carry_sprite = $CarryPrinter

var carrying: ThreeDPrinter

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			sprite.flip_h = false
		elif direction < 0:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func move_printer(printer: ThreeDPrinter):
	carrying = printer
	carry_sprite.texture = printer.tier.texture
	carry_sprite.show()


func place_printer():	
	carrying = null
	carry_sprite.texture = null
	carry_sprite.hide()
