extends AudioStreamPlayer


const accept_job = preload("res://sounds/Accept Job.mp3")
const printer_started = preload("res://sounds/Printer Started.mp3")
const money_increase = preload("res://sounds/Money Increase.mp3")
const ready_to_ship = preload("res://sounds/Shipped.mp3")


func play_accept_job():
	stream = accept_job
	play()


func play_printer_started():
	stream = printer_started
	play()


func play_money_increase():
	stream = money_increase
	play()


func play_ready_to_ship():
	stream = ready_to_ship
	play()
