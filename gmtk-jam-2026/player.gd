extends CharacterBody2D
class_name Player

const SPEED = 600.0
const JUMP_VELOCITY = -400.0

@onready var sprite = $Sprite2D
@onready var carry_sprite = $CarryPrinter

var carrying: ThreeDPrinter

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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


func on_move_printer(printer: ThreeDPrinter):
	printer.hide()
	printer.slot.printer = null
	printer.slot = null
	carrying = printer
	
	carry_sprite.texture = printer.tier.texture
	carry_sprite.show()


func on_place_printer(slot: PrinterTableSlot):
	slot.printer = carrying
	carrying.slot = slot
	carrying.global_position.x = slot.global_position.x
	carrying.show()
	
	carrying = null
	carry_sprite.texture = null
	carry_sprite.hide()


func on_swap_carrying(slot: PrinterTableSlot):
	var current_printer = slot.printer
	on_place_printer(slot)
	on_move_printer(current_printer)
