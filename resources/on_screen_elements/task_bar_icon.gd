extends TextureButton

var iconset_per_program = {
	DesktopManager.PROGRAMS.FILES: [load("res://assets/Desktop/defaultfoldericon.png"), load("res://assets/Desktop/clickedfoldericon.png"), load("res://assets/Desktop/hoverfoldericon.png")]
}

var program :DesktopManager.PROGRAMS : 
	set(value):
		program = value
		var iconset = iconset_per_program.get(program)
		if iconset != null:
			texture_normal = iconset[0]
			texture_pressed = iconset[1]
			texture_hover = iconset[2]
		#TODO change icon and stuff

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
