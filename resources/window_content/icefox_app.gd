extends Control

@onready var search_input = $LineEdit

func _ready():
	search_input.grab_focus()

	search_input.text_submitted.connect(_on_search_submitted)

func _on_search_submitted(text):
	print("Icefox searched:", text)
