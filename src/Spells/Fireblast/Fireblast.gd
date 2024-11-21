extends Area3D

var pattern = ["right", "forwards", "left", "left", "forwards", "right"]

var select_name = "Frame_Fireblast_Tex"
var feedback_name = "Fireblast_Feedback"

const timeout_ms = 2000
var starttime = - timeout_ms * 1000

func use_spell(player: CharacterBody3D):
	var burnables = get_overlapping_bodies()
	$GPUParticles3D.emitting = true
	starttime = Time.get_ticks_msec()
	for burnable in burnables:
		if burnable.has_method("burn"):
			burnable.burn()
