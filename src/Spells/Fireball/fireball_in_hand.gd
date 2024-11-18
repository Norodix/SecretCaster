extends Node3D

@onready var bufferPos = self.global_position
@onready var attractor = $GPUParticlesAttractorSphere3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	attractor.global_position = self.global_position + ((self.global_position - bufferPos) * -1.0) + Vector3(0.0,0.1,0.0)
	bufferPos = self.global_position
