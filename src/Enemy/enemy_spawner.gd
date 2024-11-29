extends Node3D

@export_file("*.tscn") var EnemyScene
@export var EnemyRadius : float = 0.5
@export var trigger_spell = SignalBus.SpellTypes.INVALID
@export var trigger_enemy_number = 1

var scene : Resource
var has_triggered = false # only trigger this on spell use once

func _ready() -> void:
	scene = load(EnemyScene)
	if not scene:
		print("Spawner scene is invalid")
		#self.queue_free()
		return
	# Connect to any number of signals on the signal bus
	SignalBus.spell_used.connect(spell_use_signaled)


func spell_use_signaled(type : int):
	if has_triggered:
		return
	if type == trigger_spell:
		has_triggered = true
		trigger_spawn(trigger_enemy_number)


const PHI = 0.618033
func trigger_spawn(count : int):
	for i in count:
		var a = PHI * 2 * PI * i
		var r = sqrt(float(i+0.7)) * EnemyRadius * 1.4
		var newpos = Vector3(1, 0, 0).rotated(Vector3.UP, a) * r
		var instance = scene.instantiate()
		self.add_child(instance)
		instance.position = newpos
