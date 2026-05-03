extends Node2D

var roll_counter = 0
var time_passed: float = 0.0
var is_halted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	time_passed += delta
	if time_passed >= 2.0:
		_slop_meter()
		time_passed = 0.0
	

func _slop_meter():
	roll_counter += 1
	var roll_dice = randi_range(1, 100)
	if roll_dice <= GameData.slopmeter: 
		# TODO
		print("ad")
	else: 
		pass
	if roll_counter >= 5:
		GameData.slopmeter += 1
		roll_counter = 0

func halt_meter():
	# TODO If player clicks away from an ad the timer gets halted for a short while 
	if is_halted: return
	
	is_halted = true
	await get_tree().create_timer(10.0).timeout
	is_halted = false

func progress_meter():
	GameData.slopmeter += 5

func check_end_condition():
	if GameData.slopmeter > 50:
		get_tree().change_scene_to_file("res://resources/end_screens/game-over-bad.tscn")
	else:
		get_tree().change_scene_to_file("res://resources/end_screens/game-over-good.tscn")
	
