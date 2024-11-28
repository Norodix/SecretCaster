extends CharacterBody3D

const speed = 30
const lifetime_ms = 5000

@onready var birthtime = Time.get_ticks_msec()
@onready var explosion_scene : Resource = preload("res://Spells/Fireball/Explosion.tscn")


func _ready() -> void:
	$AudioStreamPlayer3D.play(randf()*100)


func _physics_process(delta: float) -> void:
	if birthtime + lifetime_ms < Time.get_ticks_msec():
		self.queue_free()
	var col = move_and_collide(speed * delta * self.global_transform.basis.z * -1)
	if col:
		self.queue_free()
		spawn_explosion()
		return

func spawn_explosion():
	var explosion_instance = explosion_scene.instantiate()
	get_tree().root.add_child(explosion_instance)
	explosion_instance.global_transform.origin = self.global_transform.origin
