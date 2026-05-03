extends Control

@onready var email_list = $HBoxContainer/EmailListPanel/VBoxContainer
@onready var subject_label = $HBoxContainer/EmailReadPanel/VBoxContainer/SubjectLabel
@onready var from_label = $HBoxContainer/EmailReadPanel/VBoxContainer/FromLabel
@onready var body_label = $HBoxContainer/EmailReadPanel/VBoxContainer/BodyLabel
@onready var new_mail_sound = $NewMailSound
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
		button.text = "● " + email["subject"] + "\n" + email["from"]

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
	body_label.text = email["body"]

	for child in attachments_container.get_children():
		child.queue_free()

	if !email.get("attachments").is_empty():
		for file in email["attachments"]:
			var btn := Button.new()
			btn.text = file.file_name

			if file.icon:
				btn.icon = file.icon

			btn.pressed.connect(func():
				GameData.save_file(file)
				print("saved from click: ", file.file_name)
			)

			attachments_container.add_child(btn)

	GameData.inlook_last_opened_index = GameData.inlook_emails.find(email)
