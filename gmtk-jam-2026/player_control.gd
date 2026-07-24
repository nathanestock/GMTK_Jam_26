extends Area2D
class_name PlayerControl

signal accept
signal select_up
signal select_down

@onready var static_ui = $VBoxContainer/Static
@onready var player_ui = $VBoxContainer/Player


func _ready():
	if static_ui:
		static_ui.show()
	
	if player_ui:
		player_ui.hide()


func _input(event):
	if event is InputEventKey and player_ui.visible:
		if event.is_action_pressed("ui_accept"):
			accept.emit()
		elif event.is_action_pressed("ui_up"):
			select_up.emit()
		elif event.is_action_pressed("ui_down"):
			select_down.emit()


func _on_body_entered(body):
	if body is Player and player_ui:
		player_ui.show()


func _on_body_exited(body):
	if body is Player and player_ui:
		player_ui.hide()
