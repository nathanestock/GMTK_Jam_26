extends AudioStreamPlayer


const accept_job = preload("res://sounds/Accept Job.mp3")
const printer_started = preload("res://sounds/Printer Started.mp3")
const money_increase = preload("res://sounds/Money Increase.mp3")
const ready_to_ship = preload("res://sounds/Shipped.mp3")


func play_accept_job():
	stream = accept_job
	volume_db = 0.0
	play()


func play_printer_started():
	stream = printer_started
	volume_db = 10.0
	play()


func play_money_increase():
	stream = money_increase
	volume_db = 5.0
	play()


func play_ready_to_ship():
	stream = ready_to_ship
	volume_db = 15.0
	play()
