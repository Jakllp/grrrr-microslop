extends Control

@onready var tab_container = $TabContainer
var is_loading := false

func _ready():
	load_tabs()

func _exit_tree():
	save_tabs()

func add_sentence_tab(tab_name := "", start_text := "", file_data: FileData = null):
	if file_data != null:
		var key = file_data.resource_path
		
		for i in range(tab_container.get_child_count()):
			var child = tab_container.get_child(i)
			if child.get_meta("file_key", "") == key:
				tab_container.current_tab = i
				return

	var text_edit = TextEdit.new()
	text_edit.text = start_text
	text_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
	text_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	if file_data != null:
		text_edit.set_meta("file_key", file_data.resource_path)

	text_edit.text_changed.connect(save_tabs)

	tab_container.add_child(text_edit)

	var index = tab_container.get_tab_count() - 1

	if tab_name == "":
		tab_name = "Doc " + str(index + 1)

	tab_container.set_tab_title(index, tab_name)
	tab_container.current_tab = index

	if not is_loading:
		save_tabs()

func save_tabs():
	if is_loading:
		return

	GameData.sentence_tabs.clear()

	for i in range(tab_container.get_child_count()):
		var text_edit = tab_container.get_child(i)

		GameData.sentence_tabs.append({
			"title": tab_container.get_tab_title(i),
			"text": text_edit.text,
			"file_key": text_edit.get_meta("file_key", "")
		})

		var file_key = text_edit.get_meta("file_key", "")
		if file_key != "":
			GameData.file_contents[file_key] = text_edit.text

func load_tabs():
	is_loading = true

	if GameData.sentence_tabs.is_empty():
		is_loading = false
		add_sentence_tab()
		return

	for tab_data in GameData.sentence_tabs:
		var file_key = tab_data.get("file_key", "")
		var text_edit_file_data: FileData = null
		
		add_sentence_tab(tab_data["title"], tab_data["text"], text_edit_file_data)
		
		if file_key != "":
			var current_tab = tab_container.get_child(tab_container.get_child_count() - 1)
			current_tab.set_meta("file_key", file_key)

	is_loading = false
