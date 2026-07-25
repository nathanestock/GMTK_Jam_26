extends Node2D
class_name Game


@onready var player = $Player
@onready var cat = $Cat

enum State { PLAY_GAME, PLAYING, WON, LOST }

var state = State.PLAY_GAME

func _ready():
	_toggle_player_controls(false)
	
	player.reparent(JobManager)
	cat.reparent(JobManager)
	
	JobManager.win_game.connect(_on_win_game)


func _input(event):
	if event is InputEventKey:
		match(state):
			State.PLAY_GAME:
				if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
					_on_play_game()
			State.WON:
				if event.is_action_pressed("ui_accept"):
					_on_keep_playing()
				elif event.is_action_pressed("ui_close_dialog"):
					_on_quit()


func _on_play_game():
	state = State.PLAYING
	
	_toggle_player_controls(true)
	_toggle_countdowns(true)
	player.reparent(self)
	cat.reparent(self)
	JobManager.on_play_game()


func _on_win_game():
	state = State.WON
	
	_toggle_player_controls(false)
	_toggle_countdowns(false)
	player.reparent(JobManager)
	cat.reparent(JobManager)


func _on_keep_playing():
	state = State.PLAYING
	
	_toggle_player_controls(true)
	_toggle_countdowns(true)
	player.reparent(self)
	cat.reparent(self)
	JobManager.on_keep_playing()


func _on_quit():
	return # TODO figure out game reset
	
	state = State.PLAY_GAME
	
	_toggle_player_controls(false)
	_toggle_countdowns(false)
	JobManager.on_quit()


func _toggle_player_controls(value: bool):
	var player_controls = get_tree().get_nodes_in_group("PlayerControl")
	
	for control in player_controls:
		if value:
			control.show()
		else:
			control.hide()


func _toggle_countdowns(value: bool):
	var countdowns = get_tree().get_nodes_in_group("Countdown")
	
	for countdown in countdowns:
		if value:
			countdown.play()
		else:
			countdown.pause()
