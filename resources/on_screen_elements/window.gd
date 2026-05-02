class_name CustomWindow
extends Control

@onready var icon_rect = $MainDivision/TopBar/Icon
@onready var title_label = $MainDivision/TopBar/Title

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
	print("Hello")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hue += delta * 0.2  # speed of cycling
	if hue > 1.0:
		hue -= 1.0

	var curcol = Color.from_hsv(hue, 1.0, 1.0)
	$MainDivision/TopBar.add_theme_color_override("bg_color", curcol)

func _on_close_button_pressed() -> void:
	# TODO tell desktop I am gone
	queue_free()
