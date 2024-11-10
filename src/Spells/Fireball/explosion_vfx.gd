extends Node3D

@onready var particle = $GPUParticles3D

func _ready():
	particle.emitting = true
