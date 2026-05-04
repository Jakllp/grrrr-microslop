extends Control

enum TYPE {
	GOOD,
	BAD
}

@export var slop_bar :ProgressBar
@export var player :AudioStreamPlayer
@export var background :TextureRect
@export var type :TYPE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slop_bar.value = GameData.slopmeter
	if slop_bar.value > 50:
		if type == TYPE.GOOD:
			background.texture = load("res://assets/images/tranquilelandscape.webp")
		else:
			background.texture = load("res://assets/images/game-over-bad-high.png")
	else:
		if type == TYPE.GOOD:
			background.texture = load("res://assets/images/game-over-good-low-ai.png")
		else:
			background.texture = load("res://assets/images/96302.webp")
		
	if player != null:
		player.play()

func _on_restart_game_button_pressed() -> void:
	TaskManager.reset()
	GameData.reset()
	get_tree().change_scene_to_file("res://resources/login-screen.tscn")
