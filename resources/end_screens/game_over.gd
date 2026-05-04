extends Control

@export var slop_bar :ProgressBar
@export var player :AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slop_bar.value = GameData.slopmeter
	if player != null:
		player.play()

func _on_restart_game_button_pressed() -> void:
	get_tree().quit();
