extends Control

@onready var files_list = $FilesList
@onready var file_title_label = $FileTitleLabel
@onready var file_content_label = $FileContentsLabel

func _ready():
	GameData.file_saved.connect(refresh_files)
	refresh_files()

func refresh_files() -> void:
	# clear old buttons
	for child in files_list.get_children():
		child.queue_free()

	# add new ones
	for file in GameData.saved_files:
		var button := Button.new()
		button.text = file.file_name
		
		if file.icon:
			button.icon = file.icon
		
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT

		button.pressed.connect(func():
			open_file(file)
		)

		files_list.add_child(button)
		
func open_file(file) -> void:
	file_title_label.text = file.file_name
	file_content_label.text = file.file_content
