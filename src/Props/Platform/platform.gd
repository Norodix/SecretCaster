extends Node3D

@onready var player = get_tree().root.find_child("Player")
const offset_max = 10
const offset_min = 0
const distance_max = 20
const distance_min = 5

func _process(delta: float) -> void:
	if not player:
		player = get_tree().root.find_child("Player", true, false)
		return
	var d = global_position.distance_to(player.global_position)
	d = clamp(d, distance_min, distance_max)
	var offset = remap(d, distance_min, distance_max, offset_min, offset_max)
	$Cylinder.transform.origin.y = - offset
