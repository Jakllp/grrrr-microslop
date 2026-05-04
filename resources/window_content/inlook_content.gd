extends Control

@onready var email_list = $HBoxContainer/EmailListPanel/VBoxContainer
@onready var subject_label = $HBoxContainer/EmailReadPanel/VBoxContainer/SubjectLabel
@onready var from_label = $HBoxContainer/EmailReadPanel/VBoxContainer/FromLabel
@onready var body_label = $HBoxContainer/EmailReadPanel/VBoxContainer/MarginContainer/BodyLabel
@onready var new_mail_sound = $NewMailSound
@onready var sep = $HBoxContainer/EmailReadPanel/VBoxContainer/Sep
@onready var attachments_separator = $HBoxContainer/EmailReadPanel/VBoxContainer/AttachmentSeparator
@onready var attachments_container = $HBoxContainer/EmailReadPanel/VBoxContainer/AttachmentsContainer
	
func _ready():
	# listen for new emails (background system)
	GameData.inlook_new_email.connect(add_email)

	# load existing emails (when reopening window)
	for email in GameData.inlook_emails:
		add_email(email, false)

	# restore last opened email
	if GameData.inlook_last_opened_index != -1:
		var index = GameData.inlook_last_opened_index

		if index < GameData.inlook_emails.size():
			var email = GameData.inlook_emails[index]

			subject_label.text = email["subject"]
			from_label.text = "From: " + email["from"]
			body_label.text = email["body"]

func add_email(email, play_sound := true):
	var button = Button.new()

	if email["read"]:
		button.text = email["subject"] + "\n" + email["from"]
	else:
		button.text = "* " + email["subject"] + "\n" + email["from"]

	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	button.pressed.connect(func():
		open_email(email, button)
	)
	
	email_list.add_child(button)
	email_list.move_child(button, 0)

	if not GameData.inlook_emails.has(email):
		GameData.inlook_emails.append(email)

	if play_sound:
		new_mail_sound.play()

func open_email(email, button):
	email["read"] = true
	button.text = email["subject"] + "\n" + email["from"]

	subject_label.text = email["subject"]
	from_label.text = "From: " + email["from"]
	var email_content :String = email["body"]
	email_content = email_content.replace("%NAME%", GameData.player_name)
	body_label.text = email_content
	
	if !sep.visible:
		sep.visible = true

	for child in attachments_container.get_children():
		child.queue_free()

	if email.has("attachments") and !email.get("attachments").is_empty():
		attachments_separator.visible = true
		for file in email["attachments"]:
			var btn := Button.new()
			
			if GameData.check_file_saved(file):
				btn.text = "Saved!"
				btn.disabled = true
			else:
				btn.text = file.file_name

			if file.icon:
				btn.icon = file.icon

			btn.pressed.connect(func():
				GameData.save_file(file)
				btn.text = "Saved!"
				btn.disabled = true
				print("saved from click: ", file.file_name)
			)

			attachments_container.add_child(btn)
	else:
		attachments_separator.visible = false
	
	if email.has("task") and email["task"] != null:
		var btn := Button.new()
		var task = email["task"]
		if TaskManager.tasks_to_evaluate.has(task):
			btn.text = "Check completion!"
		else:
			btn.disabled = true
			btn.text = "Completed!"

		btn.pressed.connect(func():
			var check = TaskManager.check_task(task)
			
			if check:
				btn.text = "Completed!"
				btn.disabled = true
			else:
				btn.text = "Check again!"
		)

		attachments_container.add_child(btn)

	GameData.inlook_last_opened_index = GameData.inlook_emails.find(email)
	
