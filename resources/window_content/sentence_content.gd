extends Control

@onready var tab_container = $TabContainer
var is_loading := false

func _ready():
	load_tabs()

func _exit_tree():
	save_tabs()

func add_sentence_tab(tab_name := "", start_text := ""):
	var text_edit = TextEdit.new()
	text_edit.text = start_text
	text_edit.set_anchors_preset(Control.PRESET_FULL_RECT)
	text_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
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
			"text": text_edit.text
		})

func load_tabs():
	is_loading = true

	if GameData.sentence_tabs.is_empty():
		is_loading = false
		add_sentence_tab()
		return

	for tab_data in GameData.sentence_tabs:
		add_sentence_tab(tab_data["title"], tab_data["text"])

	is_loading = false
