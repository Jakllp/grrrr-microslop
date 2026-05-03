class_name PopupManager
extends Node2D

const MIN_SLOPMETER = 0
const MAX_SLOPMETER = 100
var roll_counter = 0
var time_passed := 0.0
var is_halted := false

enum AD_TYPES {
	LARGE,
	SMALL,
	TALL,
	WIDE
}

var ad_for_type = {
	AD_TYPES.TALL: preload("res://resources/popups/tall_popup.tscn"),
	AD_TYPES.WIDE: preload("res://resources/popups/wide_popup.tscn"),
	AD_TYPES.SMALL: preload("res://resources/popups/small_popup.tscn"),
	AD_TYPES.LARGE: preload("res://resources/popups/large_popup.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.popup_manager = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	time_passed += delta
	if time_passed >= 2.0:
		_slop_meter()
		time_passed = 0.0

func _set_slopmeter(value: int) -> void:
	GameData.slopmeter = max(MIN_SLOPMETER, min(MAX_SLOPMETER, value))

func _slop_meter():
	roll_counter += 1
	var roll_dice = randi_range(1, 100)
	if roll_dice <= GameData.slopmeter: 
		open_ad()
	if roll_counter >= 5:
		_set_slopmeter(GameData.slopmeter + 1)
		roll_counter = 0

func halt_meter():
	if is_halted: return
	
	is_halted = true
	await get_tree().create_timer(10.0).timeout
	is_halted = false

func progress_meter(amount: int):
	_set_slopmeter(GameData.slopmeter + amount)

func check_end_condition():
	if GameData.slopmeter > 50:
		get_tree().change_scene_to_file("res://resources/end_screens/game-over-bad.tscn")
	else:
		get_tree().change_scene_to_file("res://resources/end_screens/game-over-good.tscn")
	
func open_ad():
	var open_popup = ad_for_type.get(randi() % ad_for_type.size()).instantiate()
	$"../DesktopUI/PopUps".add_child(open_popup)
	open_popup.position = _calculate_random_pos_near_center(open_popup.size)
	open_popup.get_node("VideoStreamPlayer").modulate = Color(randf(), randf(), randf())
	
func _calculate_random_pos_near_center(window_size: Vector2) -> Vector2:
	var viewport_size = get_viewport_rect().size
	var x_space = viewport_size.x - window_size.x
	var y_space = viewport_size.y - window_size.y
	
	var rand_x = randi_range(0, x_space)
	var rand_y = randi_range(0, y_space)
	
	return Vector2(rand_x, rand_y)
