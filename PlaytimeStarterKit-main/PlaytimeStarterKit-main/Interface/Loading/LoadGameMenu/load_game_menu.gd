extends Control

@export var menu_popup_path: NodePath

@onready var buttons = $buttons
@onready var current = $buttons/Current
@onready var defualt = $buttons/defualt
var menu_popup: Control = null
@onready var none = $None

const LOADGAMEBUTTON = preload("res://Interface/Loading/LoadGameMenu/loadgamebutton.tscn")

func _ready():
	unload_menu()
	menu_popup = get_node(menu_popup_path)

func load_menu():
	visible = true
	current.visible = false
	if not Game.saves.size() > 0:
		none.visible = true
		return
	else:
		none.visible = false
	var y_offset = 0.0
	for i in Game.saves.size():
		var new_button = LOADGAMEBUTTON.instantiate()
		new_button.name = str("Load", i)
		buttons.add_child(new_button)
		new_button.position = defualt.position
		new_button.position.y += y_offset
		y_offset += new_button.size.y+10.0
		new_button.load_data(Game.saves[i])
 
func toggle():
	if visible:
		unload_menu()
	else:
		load_menu()

func unload_menu():
	visible = false
	if buttons.get_child_count() > 2:
		for i in buttons.get_child_count()-2:
			var path: String = str("Load", i)
			buttons.get_node(path).queue_free()

func confirm_load(load_number):
	var result = await menu_popup.prompt("Load Game", "This will load the game from the selected checkpoint.")
	if result:
		Game.checkpoint = load_number
		Game.load_checkpoint()
