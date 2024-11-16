extends Node3D

var pattern = ["forwards", "right", "backwards", "left", "forwards", "right", "backwards", "left"]
var cooldown = 1000
@onready var player = get_parent().get_parent()
@onready var cam = player.find_child("Camera3D")

func use_spell(player: CharacterBody3D):
	$GPUParticlesAttractorSphere3D.visible = true
	$Timeout.start()


func _process(delta: float) -> void:
	$GPUParticlesAttractorSphere3D.transform.basis = cam.global_transform.basis


func _on_timeout_timeout() -> void:
	$GPUParticlesAttractorSphere3D.visible = false
	pass # Replace with function body.
