extends Control

@onready var username_input = $LoginPanel/UsernameInput
@onready var password_input = $LoginPanel/PasswordInput
@onready var error_label = $LoginPanel/ErrorLabel
@onready var hint_label = $LoginPanel/HintLabel
@onready var login_button = $LoginPanel/LoginButton

func _ready():
	login_button.pressed.connect(_on_login_pressed)

func _on_login_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text

	error_label.text = ""
	hint_label.text = ""

	error_label.text = "Checking..."
	await get_tree().create_timer(1.0).timeout
	
	if username == "":
		error_label.text = "Enter login"
		return
		
	if password == "":
		error_label.text = "Enter password"
		return

	if password != "sahur":
		error_label.text = "Invalid password"
		hint_label.text = "Hint: My favorite Tun Tun"
		return

	GameData.player_name = username
	get_tree().change_scene_to_file("res://resources/main-desktop.tscn")
