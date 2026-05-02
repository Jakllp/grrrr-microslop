extends Control

@onready var text_edit: TextEdit = $TextEdit

func _ready() -> void:
	text_edit.text = GameData.notepad_text
	text_edit.text_changed.connect(_on_text_changed)

func _on_text_changed() -> void:
	GameData.notepad_text = text_edit.text
