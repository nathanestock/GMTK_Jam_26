extends Node2D


@onready var floor = $Floor
@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall

func _ready():
	var screen = get_viewport_rect().size
	floor.position.y = screen.y - 10
	left_wall.position.y = floor.position.y
	left_wall.position.x = 10
	right_wall.position.y = floor.position.y
	right_wall.position.x = screen.x - 10
