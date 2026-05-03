extends Node

var desktop_manager :DesktopManager

var inlook_emails = []
var inlook_has_started := false
var inlook_last_opened_index := -1

var saved_files: Array[FileData] = []

signal file_saved

var player_name = ""
var slopmeter = 5
var notepad_text := ""

#inlook emails
func start_inlook_system():
	if inlook_has_started:
		return

	inlook_has_started = true

	await get_tree().create_timer(1.0).timeout
	add_inlook_email({
		"from": "System Admin",
		"subject": "Welcome to Inlook",
		"body": "Your new email client has been installed successfully.",
		"read": false,
		"attachments": [load("res://files/PayMeBack.tres")]
	})

	await get_tree().create_timer(3.0).timeout
	add_inlook_email({
		"from": "Unknown Sender",
		"subject": "You should not have logged in",
		"body": "We saw what you opened.",
		"read": false,
		"attachments": []
	})
	
signal inlook_new_email(email)

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
	
