extends MeshInstance3D

var speed = 300
var start = Vector3.ZERO # start in global space
var end = Vector3.ZERO # end in global space
const thickness = 0.05
const length = 4
const sections = 20


func _ready() -> void:
	self.global_position = start


func _process(delta: float) -> void:
	var dir = (end-start).normalized()
	self.global_position += delta * speed * dir
	var m : ImmediateMesh = self.mesh
	m.clear_surfaces()
	m.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	for i in sections:
		var pos = global_position - float(i)/float(sections) * dir * length
		var pos_local = global_transform.inverse() * pos
		if not is_between_points(start, end, pos):
			continue
		var offset = (1-(float(i)/sections))*thickness / 2.0 * Vector3.UP
		m.surface_set_uv(Vector2(0, i))
		m.surface_add_vertex(pos_local + offset)
		m.surface_set_uv(Vector2(1, i))
		m.surface_add_vertex(pos_local - offset)
	m.surface_end()
	if not is_between_points(start, end + dir * length, global_position):
		self.queue_free()


func is_between_points(a : Vector3, b : Vector3, p : Vector3):
	var dir = b - a
	var dir_p = p - a
	var v_aligned = dir_p.project(dir)
	if v_aligned.dot(dir) < 0 :
		return false
	if v_aligned.length() > dir.length():
		return false
	return true
