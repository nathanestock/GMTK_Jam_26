extends Area2D
class_name PrinterTableSlot

@export var printer: ThreeDPrinter = null

@onready var place_btn = $Button

var player: Player = null


func _ready():
	if printer:
		printer.slot = self


func _on_body_entered(body):
	if body is Player and body.carrying:
		player = body
		
		if printer:
			place_btn.text = "SWAP"
		else:
			place_btn.text = "PLACE"
		
		place_btn.show()


func _on_body_exited(body):
	if body is Player:
		player = null
		place_btn.hide()


func _on_button_pressed():
	if player:
		if printer:
			player.on_swap_carrying(self)
		else:
			player.on_place_printer(self)
		
		place_btn.hide()
