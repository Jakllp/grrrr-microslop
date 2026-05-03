class_name DesktopIcon
extends TextureButton

@export var program :DesktopManager.PROGRAMS = DesktopManager.PROGRAMS.FILES
@export var title := "Program"

func _ready() -> void:
	$Label.text = title
