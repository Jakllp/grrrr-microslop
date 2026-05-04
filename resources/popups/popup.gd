extends Node

@export var slop_plus := 5
@export var slop_minus := 5
@export var player :AudioStreamPlayer

@export var dec_button :Button
@export var acc_button :Button
@export var spawn_area :Panel

func _ready() -> void:
	if player != null:
		player.play()
	
	# Button Placement
	dec_button.position = _calulate_button_pos(spawn_area.position, spawn_area.size, dec_button)
	acc_button.position = _calulate_button_pos(spawn_area.position, spawn_area.size,acc_button)

func _calulate_button_pos(anchor :Vector2, size :Vector2, button :Button) -> Vector2:
	var x_offset = randi_range(0, size.x-button.size.x)
	var y_offset = randi_range(0, size.y-button.size.y)
	return Vector2(anchor.x + x_offset, anchor.y + y_offset)

func _process(delta: float) -> void:
	pass


func _on_accept_button_pressed() -> void:
	queue_free()
	GameData.popup_manager.progress_meter(slop_plus)

func _on_decline_button_pressed() -> void:
	queue_free()
	GameData.popup_manager.progress_meter(-slop_minus)
	GameData.popup_manager.halt_meter()
