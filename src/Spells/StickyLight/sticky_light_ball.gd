extends CharacterBody3D

var stuck = false

func _physics_process(delta: float) -> void:
	if stuck:
		return
	velocity.y += -10 * delta
	var col = move_and_collide(velocity * delta)
	if col:
		stuck = true


func _on_timer_timeout() -> void:
	self.queue_free()
