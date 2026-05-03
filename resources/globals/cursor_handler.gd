extends Node

var time_since_last = 0.0
var time_per_frame = 0.075
var cur_frame = 0
var max_frames = 7

@onready var cursor :SpriteFrames = load("res://assets/cursors/cursor.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor.get_frame_texture("arrow",0))
	Input.set_custom_mouse_cursor(cursor.get_frame_texture("beam", 0), Input.CURSOR_IBEAM)
	Input.set_custom_mouse_cursor(cursor.get_frame_texture("pointer", 0), Input.CURSOR_POINTING_HAND)

func _process(delta :float) -> void:
	advance_frame(delta)

func advance_frame(delta :float) -> void:
	time_since_last += delta
	if time_per_frame < time_since_last:
		time_since_last = 0.0
		cur_frame = (cur_frame + 1) % max_frames
		
		# Switch the stuff
		match(Input.get_current_cursor_shape()):
			Input.CURSOR_POINTING_HAND:
				Input.set_custom_mouse_cursor(cursor.get_frame_texture("pointer", cur_frame), Input.CURSOR_POINTING_HAND)
			Input.CURSOR_IBEAM:
				Input.set_custom_mouse_cursor(cursor.get_frame_texture("beam", cur_frame), Input.CURSOR_IBEAM)
			_:
				Input.set_custom_mouse_cursor(cursor.get_frame_texture("arrow", cur_frame))
		#
