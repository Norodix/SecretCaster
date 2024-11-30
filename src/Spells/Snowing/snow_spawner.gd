extends Node3D

# var pattern = ["left", "right", "left", "right", "left", "right"]
@onready var pattern = Utils.generate_pattern(8)
@onready var resource = preload("res://Spells/Snowing/SnowPatch.tscn")
var cooldown = 1000

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
		instance.global_transform.origin = raycast_result.position
	SignalBus.spell_used.emit(SignalBus.SpellTypes.SNOW)
