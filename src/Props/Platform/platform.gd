extends Node3D

@onready var player = get_tree().root.find_child("Player", true, false)
const offset_max = 10
const distance_max = 10
var t : float # parametric easing function variable
var t_target : float

func _process(delta: float) -> void:
	if not player:
		player = get_tree().root.find_child("Player", true, false)
		return
	var d = global_position.distance_to(player.global_position)
	t_target = 0 if d < distance_max else 1
	t += sign(t_target - t) * 0.02
	t = clamp(t, 0, 1)
	var y = ease(t, -2) * offset_max * -1
	visible = (y > - offset_max * 0.9)
	$Cylinder.transform.origin.y = y
