@tool
extends Node3D

var start = Vector3(0, 0, 0)
var end = Vector3(0, 0, 10)
var end_node : Node3D = null
var end_loc = Vector3(0, 0, 0) # end in target node's local coordinate system
var sections = 10.0
var damage_time = true
@export var offset_scale = 0.3
@onready var cam : Camera3D = get_tree().root.get_camera_3d()

func _ready() -> void:
	$AnimationPlayer.play("Grow")


# Position audio stream player to closest point to player
func position_audio():
	if Engine.is_editor_hint():
		return
	var cam_local = global_transform.inverse() * cam.global_position
	var dir = (end-start).normalized()
	var cam_local_dot = dir.dot(cam_local)
	cam_local_dot = clamp(cam_local_dot, 0, (end-start).length())
	$AudioStreamPlayer3D.position = dir * cam_local_dot


func _process(delta: float) -> void:
	position_audio()
	if randf() > 0.4:
		return
	if end_node != null:
		# end is relative to end_node
		var end_global = end_node.global_transform * end_loc
		end = global_transform.inverse() * end_global
	retarget()
	var sections = round((end-start).length() * 0.5)
	sections = max(sections, 5)
	var im : ImmediateMesh = $MeshInstance3D.mesh
	im.clear_surfaces()
	for j in 3:
		im.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
		for i in sections + 1:
			var rel = float(i) / float(sections)
			var randomOffset = Vector3(randf(), randf(), randf()) - Vector3.ONE * 0.5
			var width_mult = (0.5 - abs(0.5-rel))
			randomOffset *= width_mult
			var p = randomOffset * offset_scale + start + (end-start) * rel
			var sideOffset = 0.3 * width_mult * Vector3(1, 0, 0).rotated(Vector3(0, 0, 1), j*PI/3.0)
			# Add "left" side
			im.surface_set_uv(Vector2(0, rel))
			im.surface_add_vertex(p - sideOffset)
			# Add "right side
			im.surface_set_uv(Vector2(1, rel))
			im.surface_add_vertex(p + sideOffset)
		im.surface_end()
	if is_instance_valid(end_node) and damage_time:
		damage_time = false
		if end_node.has_method("damage"):
			end_node.damage(1, "shock")


func _on_timer_timeout() -> void:
	self.queue_free()


func retarget() -> void:
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = global_position
	ray_query.to = global_transform * (end.normalized() * 100)
	ray_query.collision_mask = 1 | 1 << 3
	var raycast_result = space.intersect_ray(ray_query)
	if not raycast_result.is_empty():
		end_node = raycast_result.collider
		end_loc = raycast_result.collider.global_transform.inverse() * raycast_result.position


func _on_damage_tick_timeout() -> void:
	damage_time = true
