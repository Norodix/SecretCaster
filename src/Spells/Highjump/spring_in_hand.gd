@tool
extends Node3D

@export var radius = 0.3
@export var pitch = 0.2
@export var height = 0.8
@export var thickness = 0.1
@export var circle_resolution = 10

func _ready() -> void:
	var im : ImmediateMesh = $MeshInstance3D.mesh
	im.clear_surfaces()
	im.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	var n = round(circle_resolution * height / pitch)
	for i in n:
		var v = Vector3(radius, 0, 0).rotated(Vector3.UP, i * 2 * PI / float(circle_resolution))
		v.y += float(i) / float(n) * height
		im.surface_add_vertex(v)
		v.y += thickness
		im.surface_add_vertex(v)
	im.surface_end()

func spring():
	$AnimationPlayer.play("Spring")
	return
