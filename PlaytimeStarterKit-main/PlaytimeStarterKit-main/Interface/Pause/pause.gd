extends Control

@onready var object_label = $Objective/Label
@onready var settings_menu = $SettingsMenu
@onready var load_game = $LoadGame
@onready var menu_popup = $menu_popup

func _ready():
	visible = false

func _unhandled_input(_event):
	if Input.is_action_just_pressed("exit"):
		toggle_menu()

func toggle_menu():
	object_label.text = Game.current_objective
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = !visible
	visible = !visible

func _on_resume_pressed():
	toggle_menu()
func _on_restart_pressed():
	var result = await menu_popup.prompt("Restart Checkpoint", "This will reset you to your most recent checkpoint.")
	if result:
		Game.load_checkpoint()
func _on_load_pressed():
	load_game.toggle()
func _on_settings_pressed():
	settings_menu.toggle()
func _on_main_pressed():
	var result = await menu_popup.prompt("Main Menu", "Are you sure you want to return to the main menu?")
	if result:
		Game.load_scene("res://Interface/MainMenu/title_screen.tscn")
func _on_quit_pressed():
	var result = await menu_popup.prompt("Quit Game", "Are you sure you want to quit? Any unsaved progress will be lost.")
	if result:
		get_tree().quit()
