extends CharacterBody3D

var target = Vector3.ZERO
var speed = 5
var health = 10
var acceleration = 10
@onready var player = get_tree().root.find_child("Player", true, false)
enum STRATEGY {
	DIRECT,
	FLEE,
	SIDE_RIGHT,
	SIDE_LEFT,
	MAX, # should not be used and it must be the last enum
}
var strat = STRATEGY.DIRECT

@onready var animState = $Wraith_Model/AnimationTree.get("parameters/StateMachine/playback")


func damage(type : String):
	match type:
		"fire":
			health -= 5
		"colt":
			health -= 2
		"shock":
			health -= 0.5
	if health <= 0:
		destroy()


func destroy():
	self.queue_free()


func _physics_process(delta: float) -> void:
	var nextpos = $NavigationAgent3D.get_next_path_position()
	var desired_velocity = (nextpos - global_position).normalized() * speed
	if $NavigationAgent3D.is_navigation_finished():
		desired_velocity = Vector3.ZERO
		pass
	var v_error = desired_velocity - velocity
	var dv = v_error.normalized() * acceleration * delta
	dv = dv.limit_length(v_error.length())
	velocity += dv
	move_and_slide()
	
	# Generate a new transform that looks in movement direction
	var z = Vector3.ZERO
	var v = desired_velocity
	if v.length() > 0.1:
		animState.travel("Wraith_Movement")
		z = - v
		z.y = 0
		z = z.normalized()
	else:
		animState.travel("Wraith_Idle")
		z =  global_position - player.global_position
		z.y = 0
		z = z.normalized()
	var y = Vector3.UP
	var x = y.cross(z).normalized()
	var new_basis = Basis(x, y, z).orthonormalized()
	global_basis = global_basis.slerp(new_basis, 0.1)


func _on_timer_timeout() -> void:
	if not player:
		var root = get_tree().root
		player = root.find_child("Player", true, false)
		return
	# select new strategy
	if randf() < 0.1:
		strat = randi() % STRATEGY.MAX
	var offset = global_position - player.global_position
	match strat:
		STRATEGY.DIRECT:
			$NavigationAgent3D.target_position = player.global_position
		STRATEGY.FLEE:
			$NavigationAgent3D.target_position = player.global_position + offset.normalized() * 10
		STRATEGY.SIDE_RIGHT:
			var sidestep = offset.normalized().rotated(Vector3.UP, PI/2) * 10
			$NavigationAgent3D.target_position = player.global_position + sidestep
		STRATEGY.SIDE_LEFT:
			var sidestep = offset.normalized().rotated(Vector3.UP, -PI/2) * 10
			$NavigationAgent3D.target_position = player.global_position + sidestep
