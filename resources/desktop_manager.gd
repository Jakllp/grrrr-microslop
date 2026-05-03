class_name DesktopManager
extends Node2D

var window_scene = preload("res://resources/on_screen_elements/window.tscn")
var notepad_scene = preload("res://resources/window_content/NotepadApp.tscn")
var taskbaricon_scene = preload("res://resources/on_screen_elements/task_bar_icon.tscn")

enum PROGRAMS {
	FILES,
	BROWSER,
	NOTES,
	INLOOK,
	SENTENCE,
	FAIL
}

var icon_for_program = {
	PROGRAMS.FILES: load("res://assets/Desktop/defaultfoldericon.png"),
	PROGRAMS.BROWSER: load("res://assets/Desktop/icefoxicon.png"),
	PROGRAMS.NOTES: load("res://assets/Desktop/notepadicon.png"),
	PROGRAMS.INLOOK: load("res://assets/Desktop/inlookicon.png"),
	PROGRAMS.SENTENCE: load("res://assets/Desktop/sentenceicon.png"),
	PROGRAMS.FAIL: load("res://assets/Desktop/failicon.png")
}

var title_for_program = {
	PROGRAMS.FILES: "Files",
	PROGRAMS.BROWSER: "IceFox",
	PROGRAMS.NOTES: "Notes",
	PROGRAMS.INLOOK: "Macrohard Inlook",
	PROGRAMS.SENTENCE: "Macrohard Sentence",
	PROGRAMS.FAIL: "Macrohard Fail",
}

var open_windows = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttons = $"../DesktopUI/AppIcons".get_children()
	for butt :DesktopIcon in buttons:
		butt.pressed.connect(_on_desktop_icon_clicked.bind(butt))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_desktop_icon_clicked(butt :DesktopIcon) -> void:
	var program = butt.program
	
	# Check if already exists
	if open_windows.has(program):
		_push_to_front(program)
		return
	
	# Setup Window
	var window = window_scene.instantiate()
	var taskbar_icon = taskbaricon_scene.instantiate()
	
	open_windows.get_or_add(program, [window, open_windows.size() + 1, taskbar_icon])
	$"../DesktopUI/Windows".add_child(window)
	
	#Set variables
	window.z_index = open_windows.get(program)[1]
	window.icon = icon_for_program[program]
	window.title = title_for_program[program]
	window.position = _calculate_random_pos_near_center(window.size)
	
	# Content
	match program:
		PROGRAMS.NOTES:
			window.set_content(notepad_scene.instantiate())

	window.program = program
	window.on_close.connect(_close_window)
	
	$"../DesktopUI/TaskBar/OpenPrograms".add_child(taskbar_icon)
	taskbar_icon.program = program
	taskbar_icon.pressed.connect(_push_to_front.bind(program))

func _close_window(program :PROGRAMS) -> void:
	open_windows.get(program)[2].queue_free()
	open_windows.erase(program)
	#TODO taskbar

func _calculate_random_pos_near_center(window_size :Vector2) -> Vector2:
	var x_space = get_viewport_rect().size.x - window_size.x
	var y_space = get_viewport_rect().size.y - window_size.y
	
	var rand_x = randi_range(-1 * x_space/4, x_space/4)
	var rand_y = randi_range(-1 * y_space/4, y_space/4)
	
	var x = x_space / 2 + rand_x
	var y = y_space / 2 + rand_y
	return Vector2(x, y)

func _push_to_front(program :PROGRAMS) -> void:
	var wanted_prog = open_windows.get(program)
	var new_z = open_windows.size()
	var previous_z = wanted_prog[1]
	wanted_prog[0].z_index = new_z
	wanted_prog[1] = new_z
	$"../DesktopUI/Windows".move_child(wanted_prog[0], new_z-1)
	for prog in open_windows.values():
		if prog[1] > previous_z && prog != wanted_prog:
			prog[1] -= 1
			prog[0].z_index = prog[1]
