class_name DesktopManager
extends Node2D

var window_scene = preload("res://resources/on_screen_elements/window.tscn")
var notepad_scene = preload("res://resources/window_content/NotepadApp.tscn")

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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttons = $"../DesktopUI/AppIcons".get_children()#
	for butt :DesktopIcon in buttons:
		butt.pressed.connect(_on_desktop_icon_clicked.bind(butt))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_desktop_icon_clicked(butt :DesktopIcon) -> void:
	var program = butt.program
	var window = window_scene.instantiate()
	$"../DesktopUI".add_child(window)
	window.icon = icon_for_program[program]
	window.title = title_for_program[program]
	window.position = _calculate_random_pos_near_center(window.size)
	
	match program:
		PROGRAMS.NOTES:
			window.set_content(notepad_scene.instantiate())


func _calculate_random_pos_near_center(window_size :Vector2) -> Vector2:
	var x_space = get_viewport_rect().size.x - window_size.x
	var y_space = get_viewport_rect().size.y - window_size.y
	
	var rand_x = randi_range(-1 * x_space/4, x_space/4)
	var rand_y = randi_range(-1 * y_space/4, y_space/4)
	
	var x = x_space / 2 + rand_x
	var y = y_space / 2 + rand_y
	return Vector2(x, y)
