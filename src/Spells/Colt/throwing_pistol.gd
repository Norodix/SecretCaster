extends RigidBody3D

const speed = 20
var vy = 5
var start_basis
var has_contacted = false # custom contact monitoring disable
var v : Vector3


func _ready() -> void:
	var av = Vector3(randf(), randf(), randf()).normalized() * 5
	angular_velocity = av
	global_transform.basis = start_basis
	linear_velocity = speed * self.global_transform.basis.z * -1
	linear_velocity.y += vy
	v = linear_velocity


func _on_timer_timeout() -> void:
	self.queue_free()


func _on_body_entered(body: Node) -> void:
	if has_contacted:
		return
	has_contacted = true
	if body.has_method("damage"):
		body.damage("physical")
		print("damaging: ", body)
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var dv_dt = (linear_velocity - v) / delta
	if dv_dt.length() > 60:
		if not $AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.play()
	v = linear_velocity
