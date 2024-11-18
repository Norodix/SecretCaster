@tool
extends Node3D

var start = Vector3(0, 0, 0)
var end = Vector3(0, 0, 10)
var end_node : Node3D = null
var end_loc = Vector3(0, 0, 0)
var sections = 10.0
@export var offset_scale = 0.3

func _ready() -> void:
	$AnimationPlayer.play("Grow")

func _process(delta: float) -> void:
	if randf() > 0.4:
		return
	if end_node != null:
		# end is relative to end_node
		var end_global = end_node.global_transform * end_loc
		end = global_transform.inverse() * end_global
	var sections = round((end-start).length() * 0.5)
	var im : ImmediateMesh = $MeshInstance3D.mesh
	im.clear_surfaces()
	for j in 3:
		im.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
		for i in sections + 1:
			var rel = i / sections
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


func _on_timer_timeout() -> void:
	self.queue_free()
