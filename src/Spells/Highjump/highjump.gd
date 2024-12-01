extends Node3D

# var pattern = ["forwards", "forwards", "forwards", "backwards", "forwards"]
@onready var pattern = Utils.generate_pattern(8)

var select_name = "Frame_Highjump_Tex"
var feedback_name = "Highjump_Feedback"
var hand_name = "Spring-In-hand"


func _physics_process(delta: float) -> void:
	if find_parent("Player").is_on_floor():
		$GPUParticles3D.emitting = false

func use_spell(player: CharacterBody3D):
	find_parent("Player").find_child("Spring-In-hand").spring()
	player.velocity.y = 10
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer3D.play()
	SignalBus.spell_used.emit(SignalBus.SpellTypes.HIGHJUMP)
