extends Control

@onready var tab_container :TabContainer = $TabContainer

var is_loading := false
var rows := 50
var columns := 20

var current_file: SpreadsheetData = null

func _ready():
	load_sheets()

	if tab_container.get_tab_count() == 0:
		add_sheet("Sheet 1")

func _exit_tree():
	save_sheets()

func get_column_name(index: int) -> String:
	var name := ""
	index += 1

	while index > 0:
		var remainder := (index - 1) % 26
		name = char(65 + remainder) + name
		index = int((index - 1) / 26)

	return name

func get_cell_coord(row: int, column: int) -> String:
	return get_column_name(column) + str(row + 1)

func add_sheet(name := ""):
	var scroll = ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL

	var grid = GridContainer.new()
	grid.columns = columns + 1
	grid.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	grid.size_flags_vertical = Control.SIZE_SHRINK_BEGIN

	var corner = Label.new()
	corner.text = ""
	corner.custom_minimum_size = Vector2(45, 28)
	grid.add_child(corner)

	for c in range(columns):
		var header = Label.new()
		header.text = get_column_name(c)
		header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		header.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		header.custom_minimum_size = Vector2(90, 28)
		grid.add_child(header)

	for r in range(rows):
		var row_label = Label.new()
		row_label.text = str(r + 1)
		row_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		row_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row_label.custom_minimum_size = Vector2(45, 28)
		grid.add_child(row_label)

		for c in range(columns):
			var cell = LineEdit.new()
			cell.name = get_cell_coord(r, c)
			cell.custom_minimum_size = Vector2(90, 28)
			cell.text_changed.connect(save_sheets)
			cell.gui_input.connect(_on_cell_gui_input.bind(cell, r, c))
			grid.add_child(cell)

	scroll.add_child(grid)
	tab_container.add_child(scroll)

	var index = tab_container.get_tab_count() - 1

	if name == "":
		name = "Sheet " + str(index + 1)

	tab_container.set_tab_title(index, name)
	tab_container.current_tab = index

	if not is_loading:
		save_sheets()

func save_sheets():
	if is_loading:
		return

	GameData.fail_sheets.clear()

	for i in range(tab_container.get_child_count()):
		var scroll = tab_container.get_child(i)
		var grid = scroll.get_child(0)

		var sheet_data := {}

		for child in grid.get_children():
			if child is LineEdit and child.text != "":
				sheet_data[child.name] = child.text

		GameData.fail_sheets.append({
			"title": tab_container.get_tab_title(i),
			"cells": sheet_data
		})

	if current_file != null:
		GameData.file_contents[current_file.resource_path] = GameData.fail_sheets.duplicate(true)

func load_sheets():
	if GameData.fail_sheets.is_empty():
		return

	is_loading = true

	for sheet in GameData.fail_sheets:
		var sheet_title = sheet.get("title", "Sheet " + str(tab_container.get_tab_count() + 1))
		add_sheet(sheet_title)

		var scroll = tab_container.get_child(tab_container.get_child_count() - 1)
		var grid = scroll.get_child(0)

		var cells = sheet.get("cells", {})

		for child in grid.get_children():
			if child is LineEdit and cells.has(child.name):
				child.text = cells[child.name]

	is_loading = false
	
func open_spreadsheet(file_data: SpreadsheetData):
	current_file = file_data
	rows = file_data.rows
	columns = file_data.columns

	clear_sheets()

	var key = file_data.resource_path

	if GameData.file_contents.has(key):
		GameData.fail_sheets = GameData.file_contents[key].duplicate(true)
	else:
		GameData.fail_sheets = file_data.sheets.duplicate(true)

	load_sheets()

	for i in range(tab_container.get_tab_count()):
		var tabname = tab_container.get_tab_title(i)
		if tabname == file_data.file_name:
			tab_container.current_tab = i

	if tab_container.get_tab_count() == 0:
		add_sheet("Sheet 1")

func clear_sheets():
	for child in tab_container.get_children():
		tab_container.remove_child(child)
		child.queue_free()

func _on_cell_gui_input(event: InputEvent, cell: LineEdit, row: int, column: int):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			get_viewport().set_input_as_handled()
			move_to_cell(row + 1, column)

func move_to_cell(row: int, column: int):
	if row < 0 or row >= rows:
		return
	
	if column < 0 or column >= columns:
		return

	var current_scroll = tab_container.get_child(tab_container.current_tab)
	var grid = current_scroll.get_child(0)
	var coord = get_cell_coord(row, column)

	for child in grid.get_children():
		if child is LineEdit and child.name == coord:
			child.grab_focus()
			return
