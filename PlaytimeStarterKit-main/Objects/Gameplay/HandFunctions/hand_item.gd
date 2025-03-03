extends Node3D

@onready var hand_grab = $HandGrab

@export var hand_scene: PackedScene
@export var play_collect_sound: bool = true

func collect():
	hand_grab.release_grabbed()
	if play_collect_sound:
		Grabpack.player.sound_manager.collect()
	Grabpack.add_hand(hand_scene)
	
	queue_free()

func _on_hand_grab_let_go(_hand):
	collect()
func _on_basic_interaction_player_interacted():
	collect()
