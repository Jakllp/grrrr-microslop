extends Node

var desktop_manager :DesktopManager
var popup_manager :PopupManager

var inlook_emails = []
var inlook_has_started := false
var inlook_last_opened_index := -1

var saved_files: Array[FileData] = []

var file_contents := {}  # key: FileData, value: String

var sentence_tabs := []
var fail_sheets = []

signal file_saved

var player_name = ""
var slopmeter = 5
var notepad_text := ""

#inlook emails
func start_inlook_system():
	if inlook_has_started:
		return

	inlook_has_started = true
	
	add_inlook_email({
		"from": "Seb",
		"subject": "Last quarters data",
		"body": "I've attached the data.",
		"read": true,
		"attachments": [load("res://files/test_spreadsheet.tres")]
	})

	await get_tree().create_timer(1.0).timeout
	add_inlook_email({
		"from": "System Admin",
		"subject": "Welcome to Inlook",
		"body": "Your new email client has been installed successfully.",
		"read": false,
		"attachments": []
	})
	
signal inlook_new_email(email)

func add_task(task :Task):
	if task.task_goal is SentenceGoal or task.task_goal is FailGoal:
		add_inlook_email({
			"from": task.task_sender,
			"subject": task.task_subject,
			"body": task.task_content,
			"read": false,
			"attachments": [task.task_goal.attachment],
			"task": task
		})

func add_inlook_email(email):
	inlook_emails.append(email)
	inlook_new_email.emit(email)

func save_file(file: FileData) -> void:
	if file == null:
		return
	
	if saved_files.has(file):
		return

	saved_files.append(file)
	file_saved.emit()

func check_file_saved(query_file :FileData) -> bool:
	for file in saved_files:
		if file.file_name == query_file.file_name:
			return true
	return false
