extends Node2D
class_name ThreeDPrinter

signal finished_print

@export var tier: ThreeDPrinterTier

@onready var sprite = $Sprite2D


enum State { IDLE, PRINTING, DONE }

var state: State = State.IDLE


func _ready():
	sprite.texture = tier.texture


func is_idle() -> bool:
	return state == State.IDLE
