extends Node

@export var slop_plus := 5
@export var slop_minus := 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_accept_button_pressed() -> void:
	queue_free()
	GameData.popup_manager.progress_meter(slop_plus)

func _on_decline_button_pressed() -> void:
	queue_free()
	GameData.popup_manager.progress_meter(-slop_minus)
	GameData.popup_manager.halt_meter()
