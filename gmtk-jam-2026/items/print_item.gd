extends Resource
class_name PrintItem

@export var material: int = 0
@export var print_time: int = 0

var color: Color
var state: State = State.REQUIRED

enum State { REQUIRED, PRINTING, COMPLETED }

func is_open():
	return state == State.REQUIRED


func is_printing():
	return state == State.PRINTING


func is_completed():
	return state == State.COMPLETED


func set_is_printing():
	state = State.PRINTING


func set_is_completed():
	state = State.COMPLETED
