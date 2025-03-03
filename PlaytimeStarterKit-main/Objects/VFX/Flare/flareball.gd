extends RigidBody3D

@onready var gpu_particles_3d = $GPUParticles3D
@onready var omni_light_3d = $OmniLight3D
@onready var impact = $Impact

var frame: float = 0.0
var frame_1: float = 0.0

func _process(delta):
	frame += 1.0 * delta
	if frame > 10:
		queue_free()
	if gpu_particles_3d.amount < 2:
		gpu_particles_3d.emitting = false
		if omni_light_3d.light_energy > 0.0:
			omni_light_3d.light_energy -= 1.0 * delta
		return
	frame_1 += 5.0 * delta
	if frame_1 > 1.0:
		frame_1 = 0.0
		gpu_particles_3d.amount -= 1

func _on_body_entered(_body):
	impact.play()
