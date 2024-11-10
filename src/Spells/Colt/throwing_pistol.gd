extends Node3D

const speed = 10
var vy = 2

func _process(delta: float) -> void:
	vy += -10*delta
	self.global_transform.origin += speed * delta * self.global_transform.basis.z * -1
	self.global_transform.origin += vy * delta * Vector3.UP
	$colt.rotate($colt.basis.x.normalized(), 2*PI*3*delta)

func _on_timer_timeout() -> void:
	self.queue_free()
