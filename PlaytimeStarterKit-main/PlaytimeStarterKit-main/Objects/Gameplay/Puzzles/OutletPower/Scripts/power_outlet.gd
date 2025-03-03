extends StaticBody3D

@export var enabled: bool = true

@onready var light = $OmniLight3D
@onready var grabbed = $Grabbed
@onready var released = $Released
@onready var powering = $Powering

var current_hands: int = 0
var using: bool = false

const WIRE_OUTLET_MATERIAL = preload("res://Player/Grabpack/Wire/WireOutletMaterial.tres")

func _ready():
	if not enabled:
		set_power(false)

func set_power(value):
	light.visible = value
	enabled = value

func used(use_mode: bool):
	using = use_mode
	if use_mode:
		Grabpack.power_wire(WIRE_OUTLET_MATERIAL)
		grabbed.play()
		powering.play()
	else:
		Grabpack.dispower_wire()
		released.play()
		powering.stop()

func _on_hand_grab_grabbed(_hand):
	current_hands += 1
	if current_hands > 2:
		current_hands = 2
	if current_hands == 1 and enabled:
		used(true)

func _on_hand_grab_let_go(_hand):
	current_hands -= 1
	if current_hands < 0:
		current_hands = 0
	if current_hands < 1:
		used(false)
