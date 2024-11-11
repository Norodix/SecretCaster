extends CharacterBody3D

var stuck = false
var goalpoint = Vector3.ZERO

func _physics_process(delta: float) -> void:
	if stuck:
		global_position = lerp(global_position, goalpoint, 0.02)
		return
	velocity.y += -10 * delta
	var col = move_and_collide(velocity * delta)
	if col:
		stuck = true
		goalpoint = col.get_normal() * 2 + col.get_position()


func _on_timer_timeout() -> void:
	self.queue_free()
