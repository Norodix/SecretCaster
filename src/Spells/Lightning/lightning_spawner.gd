extends Node3D

var pattern = ["backwards", "backwards", "backwards"]
@onready var resource = preload("res://Spells/Lightning/LightningStrike.tscn")

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
		instance.global_transform.basis = player.find_child("Camera3D").global_transform.basis
		instance.global_transform.origin = player.global_transform.origin
		instance.end = instance.global_transform.inverse() * raycast_result.position
	
