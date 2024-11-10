extends Node3D

const lifetime = 5000
@onready var birthtime = Time.get_ticks_msec()

func _ready() -> void:
	$Timeout.timeout
	await get_tree().physics_frame
	var burnables = $BurnArea.get_overlapping_bodies()
	for burnable in burnables:
		if burnable.has_method("burn"):
			burnable.burn()


func _on_timeout_timeout() -> void:
	self.queue_free()
