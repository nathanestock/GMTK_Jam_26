extends Area2D
class_name PlayerControl

signal player_entered(player: Player)
signal accept
signal select_up
signal select_down

@export var allow_while_carrying = false

@onready var static_ui = $VBoxContainer/Static
@onready var player_ui = $VBoxContainer/Player

var player: Player = null


func _ready():
	add_to_group("PlayerControl")
	
	if static_ui:
		static_ui.show()
	
	if player_ui:
		player_ui.hide()


func _input(event):
	if event is InputEventKey and visible and player_ui.visible:
		if event.is_action_pressed("ui_accept"):
			accept.emit()
		elif event.is_action_pressed("ui_up"):
			select_up.emit()
		elif event.is_action_pressed("ui_down"):
			select_down.emit()
		
		get_viewport().set_input_as_handled()


func _on_body_entered(body):
	if body is Player and player_ui:
		player = body
		
		if player.carrying and not allow_while_carrying:
			return
		
		player_ui.show()
		player_entered.emit(body)


func _on_body_exited(body):
	if body is Player and player_ui:
		player = null
		player_ui.hide()
