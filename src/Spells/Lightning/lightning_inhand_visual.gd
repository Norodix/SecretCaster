@tool
extends Node3D

var start = Vector3(0,0,0)
var end = Vector3(3,0,0)
var sections = 10.0
@export var offset_scale = 1.7

func _process(delta: float) -> void:
	if randf() > 0.4:
		return
	var sections = round((end-start).length() * 0.5)
	var im : ImmediateMesh = $Lightning_01.mesh
	im.clear_surfaces()
	im.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in sections + 1:
		var rel = i / sections
		var randomOffset = Vector3(randf(), randf(), randf()) - Vector3.ONE * 0.5
		randomOffset *= (0.5 - abs(0.5-rel))
		var p = randomOffset * offset_scale + start + (end-start) * rel
		var sideOffset = 0.3 * (0.5 - abs(0.5-rel)) * Vector3(1, 0, 0)
		# Add "left" side
		im.surface_set_uv(Vector2(0, rel))
		im.surface_add_vertex(p - sideOffset)
		# Add "right side
		im.surface_set_uv(Vector2(1, rel))
		im.surface_add_vertex(p + sideOffset)
	im.surface_end()


func _on_timer_timeout() -> void:
	self.queue_free()
