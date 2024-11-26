extends Node3D

@export_file("*.tscn") var EnemyScene
@export var EnemyRadius : float = 0.5

var scene : Resource
var num_to_spawn : int = 0

func _ready() -> void:
	scene = load(EnemyScene)
	if not scene:
		print("Spawner scene is invalid")
		#self.queue_free()
	trigger_spawn(20)


const PHI = 0.618033
func trigger_spawn(count : int):
	for i in count:
		var a = PHI * 2 * PI * i
		var r = sqrt(float(i+0.7)) * EnemyRadius * 1.4
		var newpos = Vector3(1, 0, 0).rotated(Vector3.UP, a) * r
		var instance = scene.instantiate()
		self.add_child(instance)
		instance.position = newpos
