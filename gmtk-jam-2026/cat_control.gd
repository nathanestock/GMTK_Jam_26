extends Area2D

signal player_entered(player: Player)
signal pet

@onready var static_ui = $Labels/Static 
@onready var player_ui = $Labels/Player

var player: Player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _input(event):
	if event is InputEventKey and player_ui.visible and static_ui.visible:
		if event.is_action_pressed("ui_pet"):
			pet.emit()
			

func _on_body_entered(body):
	if body is Player and player_ui and static_ui.visible:
		player = body
		player_ui.show()
		player_entered.emit(body)


func _on_body_exited(body):
	if body is Player and player_ui:
		player = null
		player_ui.hide()
