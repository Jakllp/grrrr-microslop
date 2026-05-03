class_name CustomWindow
extends Control

@onready var icon_rect = $MainDivision/TopBar/Icon
@onready var title_label = $MainDivision/TopBar/Title

#var content :Control
@onready var content_container = $MainDivision/ContentContainer

var toggle_move := false
var last_mouse_pos :Vector2
var last_window_pos :Vector2

func set_content(new_content: Control) -> void:
	for child in content_container.get_children():
		child.queue_free()

	content_container.add_child(new_content)

	new_content.set_anchors_preset(Control.PRESET_FULL_RECT)
	new_content.offset_left = 0
	new_content.offset_top = 0
	new_content.offset_right = 0
	new_content.offset_bottom = 0
	
var program :DesktopManager.PROGRAMS

signal on_close(program :DesktopManager.PROGRAMS)

var content :Control
var title = "WindowTitle" :
	set(value):
		title_label.text = value
var icon :Texture2D :
	set(value):
		icon_rect.texture = value

var hue := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hue += delta * 0.2  # speed of cycling
	if hue > 1.0:
		hue -= 1.0

	var curcol = Color.from_hsv(hue, 1.0, 1.0)
	$MainDivision/TopBar.add_theme_color_override("bg_color", curcol)
	
	# Do window movement
	if toggle_move:
		var quartersize = size/4
		global_position.x = clamp(last_window_pos.x + (get_viewport().get_mouse_position().x - last_mouse_pos.x), 0 - quartersize.x, 1920 - quartersize.x)
		global_position.y = clamp(last_window_pos.y + (get_viewport().get_mouse_position().y - last_mouse_pos.y), 0, 1080 - quartersize.y)

func set_click_capture(state :bool) -> void:
	$ClickCapturer.visible = state

func _on_close_button_pressed() -> void:
	on_close.emit(program)
	queue_free()


func _on_top_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		toggle_move = event.pressed
		last_mouse_pos = get_viewport().get_mouse_position()
		last_window_pos = global_position


func _on_click_capturer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		GameData.desktop_manager.push_to_front(program)
