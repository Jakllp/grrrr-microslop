extends Node

var time_since_last = 0.0
var time_per_frame = 0.5
var cur_frame = 0
var max_frames = 3

@onready var cursor :SpriteFrames = load("res://assets/cursors/cursor.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor.get_frame_texture("arrow",0))


func advance_frame(delta :float) -> void:
	time_since_last += delta
	if time_per_frame < time_since_last:
		time_since_last = 0.0
		cur_frame = (cur_frame + 1) % max_frames
		
		# Switch the stuff
		Input.set_custom_mouse_cursor(cursor.get_frame_texture("arrow", cur_frame))
		Input.set_custom_mouse_cursor(cursor.get_frame_texture("beam", cur_frame), Input.CURSOR_IBEAM)
		Input.set_custom_mouse_cursor(cursor.get_frame_texture("pointer", cur_frame), Input.CURSOR_POINTING_HAND)
