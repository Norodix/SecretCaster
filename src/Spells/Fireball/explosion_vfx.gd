extends Node3D

@onready var particle = $GPUParticles3D

func _ready():
	particle.emitting = true


func _on_flash_timer_timeout() -> void:
	$OmniLight3D.visible = false
