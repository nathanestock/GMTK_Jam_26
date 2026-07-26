extends Node2D
class_name Game

const music_intro = preload("res://sounds/Music Intro.wav")
const music_loop = preload("res://sounds/Music Loop.wav")

@onready var player = $Player
@onready var cat = $Cat
@onready var music = $Music

enum State { PLAY_GAME, PLAYING, WON, LOST }

var state = State.PLAY_GAME

func _ready():
	_toggle_player_controls(false)
	
	player.reparent(JobManager)
	cat.reparent(JobManager)
	
	JobManager.win_game.connect(_on_win_game)
	JobManager.loss_game.connect(_on_lose_game)
	
	_play_music()


func _play_music():
	if music.finished.is_connected(_loop_music):
		music.finished.disconnect(_loop_music)
	music.stream = music_intro
	music.play()
	
	await music.finished
	music.stream = music_loop
	music.play()
	music.finished.connect(_loop_music)

func _loop_music():
	music.stream = music_loop
	music.play()


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
			State.LOST:
				if event.is_action_pressed("ui_accept"):
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


func _on_lose_game():
	state = State.LOST
	
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
	state = State.PLAY_GAME
	
	_toggle_player_controls(false)
	_toggle_countdowns(false)
	JobManager.on_quit()
	
	_play_music()


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
