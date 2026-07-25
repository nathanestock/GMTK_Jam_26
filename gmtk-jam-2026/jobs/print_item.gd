extends Resource
class_name PrintItem

@export var job: PrintJob
@export var material: int = 0
@export var print_time: int = 0

var color: Color
var state: State = State.REQUIRED

enum State { REQUIRED, PRINTING, COMPLETED, PICKED_UP }

func is_unassigned():
	return state == State.REQUIRED


func is_printing():
	return state == State.PRINTING


func is_completed():
	return state == State.COMPLETED


func is_picked_up():
	return state == State.PICKED_UP


func set_is_printing():
	state = State.PRINTING


func set_is_completed():
	state = State.COMPLETED


func set_is_picked_up():
	state = State.PICKED_UP
