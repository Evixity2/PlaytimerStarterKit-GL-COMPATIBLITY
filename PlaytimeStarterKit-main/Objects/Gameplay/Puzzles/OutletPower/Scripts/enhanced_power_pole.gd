extends StaticBody3D

@onready var puzzle_pole_handle = $PuzzlePoleHandle
@onready var laser = $PuzzlePoleHandle/Laser
@onready var ray_cast_3d = $PuzzlePoleHandle/RayCast3D
@onready var animation_player = $AnimationPlayer
@onready var hand_grab = $PuzzlePoleHandle/PuzzlePole_LowerFlap/HandGrab
@onready var hand_grab_turret = $PuzzlePoleHandle/PuzzlePole_LowerFlap/HandGrabTurret

var hands: int = 0
var handle_rotation: Vector3 = Vector3.ZERO
var rotate_speed: float = 300.0

var pushing: bool = false
var push_hand: bool = false
var is_turret: bool = false
var hand_node: Node3D = null
var is_powered: bool = false

func _ready():
	handle_rotation = puzzle_pole_handle.rotation_degrees

func _process(delta):
	if hands > 0:
		if Input.is_action_just_pressed("rotate_left"):
			handle_rotation.y = handle_rotation.y-90
		elif Input.is_action_just_pressed("rotate_right"):
			handle_rotation.y = handle_rotation.y+90
		laser.visible = true
		laser.scale.x = ray_cast_3d.global_position.distance_to(ray_cast_3d.get_collision_point())
	else:
		laser.visible = false
	if puzzle_pole_handle.rotation_degrees.y < handle_rotation.y:
		puzzle_pole_handle.rotation_degrees.y += rotate_speed * delta
	elif puzzle_pole_handle.rotation_degrees.y > handle_rotation.y:
		puzzle_pole_handle.rotation_degrees.y -= rotate_speed * delta
	if abs(puzzle_pole_handle.rotation_degrees.y - handle_rotation.y) < 1.0:
		puzzle_pole_handle.rotation_degrees.y = handle_rotation.y
	
	if Input.is_action_just_pressed("toggle_grabpack"):
		animation_player.play("hit_back")
		hand_grab.update_every_frame = false
		hand_grab_turret.release_grip()

func _on_hand_grab_grabbed(hand):
	hands += 1
	if hand:
		Grabpack.right_hand.wire_wrap = false
	else:
		Grabpack.left_hand.wire_wrap = false
func _on_hand_grab_let_go(hand):
	hands -= 1
	if hand:
		Grabpack.right_hand.wire_wrap = true
	else:
		Grabpack.left_hand.wire_wrap = true

func grab_hand(hand):
	if is_turret: return
	pushing = true
	push_hand = hand
	hand_grab.update_every_frame = true
	if hand:
		if Grabpack.right_hand.hand_retracting:
			animation_player.play("hit_back")
			hand_grab.update_every_frame = false
		else:
			animation_player.play("hit")
		Grabpack.right_hand.wire_unwrap = false
	else:
		if Grabpack.left_hand.hand_retracting:
			animation_player.play("hit_back")
			hand_grab.update_every_frame = false
		else:
			animation_player.play("hit")
		Grabpack.left_hand.wire_unwrap = false
func remove_hand(_hand):
	pushing = false
func hand_launch():
	if is_turret:
		hand_grab_turret.release_grip()
		hand_node.hand_grab_point = ray_cast_3d.get_collision_point()
		#hand_node.wire_unwrap = true
		return
	if pushing:
		hand_grab.update_every_frame = false
		if push_hand:
			Grabpack.right_position(ray_cast_3d.get_collision_point())
			Grabpack.right_hand.hand_changed_point = false
		else:
			Grabpack.left_position(ray_cast_3d.get_collision_point())
			Grabpack.left_hand.hand_changed_point = false

func _on_hand_grab_turret_grabbed(hand):
	is_turret = true
	hand_node = hand
	hand.wire_unwrap = false
	if hand.hand_retracting:
		animation_player.play("hit_back")
		hand_grab_turret.release_grip()
	else:
		animation_player.play("hit")
func _on_hand_grab_turret_let_go(hand):
	is_turret = false
	hand_node = hand
