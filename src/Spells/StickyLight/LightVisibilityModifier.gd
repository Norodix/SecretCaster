extends Node3D

var maxd = 5 # TODO this should not be hardcoded

func _process(delta: float) -> void:
	var bodies = $Area3D.get_overlapping_bodies()
	var alpha = 0.0
	for body in bodies:
		var d = body.global_position.distance_to(global_position)
		var newalpha = 1 - (d/maxd)
		alpha = max(alpha, newalpha)
	get_parent_node_3d().transparency = 1.0 - alpha
	
	
