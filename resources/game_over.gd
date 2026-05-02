extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var restartbutton = Button.new()
	restartbutton.text = "Restart"
	restartbutton.pressed.connect(restartGame)
	self.add_child(restartbutton)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restartGame() -> void:
	print("Restart me!")
	pass

func _on_quit_game_button_pressed() -> void:
	$QuitGameButton.queue_free();
