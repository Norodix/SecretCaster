extends Node3D

var pattern = ["forwards", "right", "backwards", "left", "forwards", "right", "backwards", "left"]
var cooldown = 1000
@onready var player = get_parent().get_parent()
@onready var cam = player.find_child("Camera3D")
var select_name = "Frame_Wind_Tex"
var feedback_name = "Wind_Feedback"
var hand_name = "Wind_In-hand"

func use_spell(player: CharacterBody3D):
	$GPUParticlesAttractorSphere3D.visible = true
	$Timeout.start()
	var bodies = $BlowArea.get_overlapping_bodies()
	for body in bodies:
		var d = body.global_position - global_position
		var power = remap(d.length(), 3, 10, 1, 0)
		power = clamp(power, 0, 1)
		body.velocity = d.normalized() * 20 * power


func _process(delta: float) -> void:
	$GPUParticlesAttractorSphere3D.transform.basis = cam.global_transform.basis


func _on_timeout_timeout() -> void:
	$GPUParticlesAttractorSphere3D.visible = false
	pass # Replace with function body.
