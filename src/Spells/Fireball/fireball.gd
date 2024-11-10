extends Node3D

const speed = 10
const lifetime_ms = 5000

@onready var birthtime = Time.get_ticks_msec()
@onready var explosion_scene : Resource = preload("res://Spells/Fireball/Explosion_VFX.tscn")

func _process(delta: float) -> void:
	self.global_transform.origin += speed * delta * self.global_transform.basis.z * -1
	if birthtime + lifetime_ms < Time.get_ticks_msec():
		self.queue_free()

func _physics_process(delta: float) -> void:
	var burnables = $BurnArea.get_overlapping_bodies()
	for burnable in burnables:
		if burnable.has_method("burn"):
			burnable.burn()
			self.queue_free()
			spawn_explosion()
			return
	var bodies = $HitArea.get_overlapping_bodies()
	if not bodies.is_empty():
		self.queue_free()
		spawn_explosion()
		return

func spawn_explosion():
	var explosion_instance = explosion_scene.instantiate()
	get_tree().root.add_child(explosion_instance)
	explosion_instance.global_transform.origin = self.global_transform.origin
