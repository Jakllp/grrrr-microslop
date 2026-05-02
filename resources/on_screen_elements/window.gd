class_name CustomWindow
extends Control

@onready var icon_rect = $MainDivision/TopBar/Icon
@onready var title_label = $MainDivision/TopBar/Title

#var content :Control
@onready var content_container = $MainDivision/ContentContainer

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

func _on_close_button_pressed() -> void:
	on_close.emit(program)
	queue_free()
