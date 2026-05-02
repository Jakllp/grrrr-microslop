extends Control

@export var content :Control
@export var title = "WindowTitle" :
	set(value):
		$MainDivision/TopBar/Title.text = value
@export var icon :Resource :
	set(value):
		$MainDivision/TopBar/TextureRect.texture = value
	

var hue := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainDivision/TopBar/Title.text = title
	$MainDivision/TopBar/TextureRect.texture = icon

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
