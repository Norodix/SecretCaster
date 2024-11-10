extends Area3D

const speed = 10
const lifetime_ms = 5000

@onready var birthtime = Time.get_ticks_msec()

func _process(delta: float) -> void:
	self.global_transform.origin += speed * delta * self.global_transform.basis.z * -1
	if birthtime + lifetime_ms < Time.get_ticks_msec():
		self.queue_free()

func _physics_process(delta: float) -> void:
	var burnables = get_overlapping_bodies()
	for burnable in burnables:
		if burnable.has_method("burn"):
			burnable.burn()
			self.queue_free()
