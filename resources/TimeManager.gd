extends Node

@onready var time_label = $"../DesktopUI/TaskBar/ClockLabel"
@onready var date_label = $"../DesktopUI/TaskBar/DateLabel"

var start_hour = 8
var end_hour = 16

var current_time_minutes = 0.0
var real_seconds_per_game_hour = 60.0

func _ready():
	current_time_minutes = 0.0

func _process(delta):
	var game_minutes_per_second = 60.0 / real_seconds_per_game_hour
	current_time_minutes += delta * game_minutes_per_second
	
	time_label.text = get_time_string()
	date_label.text = get_date_string()
	
	check_time()

func check_time():
	var total_minutes = int(current_time_minutes)
	var hours_passed = total_minutes / 60
	var current_hour = start_hour + hours_passed
	
	if current_hour >= end_hour:
		game_over()

func game_over():
	get_tree().change_scene_to_file("res://resources/end_screens/game-over-good.tscn")

func get_time_string():
	var total_minutes = int(current_time_minutes)
	var hours = start_hour + total_minutes / 60
	var minutes = total_minutes % 60
	
	return "%02d:%02d" % [hours, minutes]

func get_date_string():
	var dt = Time.get_datetime_dict_from_system()
	return "%02d.%02d.%04d" % [dt.day, dt.month, dt.year]
