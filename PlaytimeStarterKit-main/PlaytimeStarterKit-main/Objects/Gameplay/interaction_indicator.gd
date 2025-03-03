extends Node3D

##The distance the player must be from the indicator for it to appear
@export var radius: float = 2.5
@export var enabled: bool = true
@export var uses_check_function: bool = false
@export var check_function_node: NodePath
@export var check_function_name: String
@export var player_requires_item: bool = false
@export var item_list_name: String = ""
@export var item_name: String = ""

const ITEM_OUTLINE = preload("res://Objects/VFX/Item/item_outline.tres")

func _ready():
	visible = false
	$Area/CollisionShape3D.shape.radius = radius

func _on_area_body_entered(body):
	if body.is_in_group("Player"):
		if not enabled:
			return
		if uses_check_function:
			var node = get_node(check_function_node)
			if not node.call(check_function_name):
				return
		if player_requires_item:
			var has_item = Inventory.scan_list(item_list_name, item_name)
			if not has_item:
				return
		visible = true

func _on_area_body_exited(body):
	if body.is_in_group("Player"):
		visible = false
