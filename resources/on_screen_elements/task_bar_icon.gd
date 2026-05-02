extends TextureButton

var iconset_per_program = {
	DesktopManager.PROGRAMS.FILES: [load("res://assets/Desktop/defaultfoldericon.png"), load("res://assets/Desktop/clickedfoldericon.png"), load("res://assets/Desktop/hoverfoldericon.png")],
	DesktopManager.PROGRAMS.BROWSER: [load("res://assets/Desktop/icefoxicon.png"), load("res://assets/Desktop/clickedicefoxicon.png"), load("res://assets/Desktop/hoveredicefoxicon.png")],
	DesktopManager.PROGRAMS.NOTES: [load("res://assets/Desktop/notepadicon.png"), load("res://assets/Desktop/clickednotepadicon.png"), load("res://assets/Desktop/hovernotepadicon.png")],
	DesktopManager.PROGRAMS.INLOOK: [load("res://assets/Desktop/inlookicon.png"), load("res://assets/Desktop/clickedinlookicon.png"), load("res://assets/Desktop/hoveredinlookicon.png")],
	DesktopManager.PROGRAMS.SENTENCE: [load("res://assets/Desktop/sentenceicon.png"), load("res://assets/Desktop/clickedsentenceicon.png"), load("res://assets/Desktop/hoversentenceicon.png")],
	DesktopManager.PROGRAMS.FAIL: [load("res://assets/Desktop/failicon.png"), load("res://assets/Desktop/clickedfailicon.png"), load("res://assets/Desktop/hoverfailicon.png")],
}

var program :DesktopManager.PROGRAMS : 
	set(value):
		program = value
		var iconset = iconset_per_program.get(program)
		if iconset != null:
			texture_normal = iconset[0]
			texture_pressed = iconset[1]
			texture_hover = iconset[2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
