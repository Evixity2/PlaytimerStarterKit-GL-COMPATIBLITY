extends Button

@export var setting_name: String = ""
@export var setting_description:  String = ""
@export var settings_root: NodePath

var setting_node: Control = null

func _ready():
	connect("mouse_entered", Callable(send_data))
	setting_node = get_node(settings_root)
	connect("mouse_exited", Callable(setting_node.setting_exited))

func send_data():
	setting_node.setting_pressed(setting_name, setting_description, position.y)
