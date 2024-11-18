extends Node3D

var pattern = ["backwards", "backwards", "backwards"]
@onready var resource = preload("res://Spells/Lightning/LightningStrike.tscn")
var select_name = "Frame_Lightning_Tex"
var feedback_name = "Lightning_Feedback"

func use_spell(player: CharacterBody3D):
	var instance = resource.instantiate()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = 1
	var raycast_result = space.intersect_ray(ray_query)
	if not raycast_result.is_empty():
		get_tree().root.add_child(instance, true)
		instance.global_transform.basis = camera.global_transform.basis
		var randomoffset = Vector3(0.2, 0.2, 0).rotated(Vector3(0, 0, 1), randf()*10000)
		var offset = randomoffset + Vector3(0, 0, -1)
		instance.global_transform.origin = camera.global_transform * offset
		instance.end = instance.global_transform.inverse() * raycast_result.position
		instance.end_node = raycast_result.collider
		instance.end_loc = raycast_result.collider.global_transform.inverse() * raycast_result.position
	
