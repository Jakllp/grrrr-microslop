extends Control

@export var slop_bar :ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slop_bar.value = GameData.slopmeter

func _on_restart_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://resources/login-screen.tscn");
