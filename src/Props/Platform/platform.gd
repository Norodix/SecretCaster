extends Node3D

@onready var player = get_tree().root.find_child("Player")
const offset_max = 10
const offset_min = 0
const distance_max = 10
const distance_min = 5
var offset_target = 0

func _process(delta: float) -> void:
	if not player:
		player = get_tree().root.find_child("Player", true, false)
		return
	var d = global_position.distance_to(player.global_position)
	if d < distance_max:
		#visible = true
		offset_target = offset_min
	else:
		#visible = false
		offset_target = offset_max
	var y = $Cylinder.transform.origin.y
	y = lerp(y, float(- offset_target), 0.04)
	visible = (y > - offset_max * 0.9)
	$Cylinder.transform.origin.y = y
