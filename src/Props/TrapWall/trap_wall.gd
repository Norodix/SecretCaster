extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("damage"):
		body.damage(10, "physical")
