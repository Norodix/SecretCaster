extends Node3D

var pattern = ["forwards", "forwards", "forwards", "backwards", "forwards"]

var select_name = "Frame_Highjump_Tex"
var feedback_name = "Highjump_Feedback"


func _physics_process(delta: float) -> void:
	if find_parent("Player").is_on_floor():
		$GPUParticles3D.emitting = false

func use_spell(player: CharacterBody3D):
	player.velocity.y = 10
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer3D.play()
	SignalBus.spell_used.emit(SignalBus.SpellTypes.HIGHJUMP)
