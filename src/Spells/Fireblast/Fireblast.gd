extends Area3D

var pattern = ["right", "forwards", "left", "left", "forwards", "right"]

var select_name = "Frame_Fireblast_Tex"
var feedback_name = "Fireblast_Feedback"
var hand_name = "Fireblast-In-hand"


func use_spell(player: CharacterBody3D):
	$AudioStreamPlayer3D.play()
	var burnables = get_overlapping_bodies()
	$GPUParticles3D.emitting = true
	for burnable in burnables:
		if burnable.has_method("burn"):
			burnable.burn()
		if burnable.has_method("damage"):
			burnable.damage(3, "fire")
