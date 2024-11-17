extends CharacterBody3D

var target = Vector3.ZERO
var speed = 5
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


func burn():
	destroy()


func destroy():
	self.queue_free()


func _physics_process(delta: float) -> void:
	var nextpos = $NavigationAgent3D.get_next_path_position()
	velocity = (nextpos - global_position).normalized() * speed
	if $NavigationAgent3D.is_navigation_finished():
		velocity = Vector3.ZERO
	move_and_slide()
	
	# Generate a new transform that looks in movement direction
	var z = Vector3.ZERO
	if velocity.length() > 0.1:
		z = - velocity
		z.y = 0
		z = z.normalized()
	else:
		z =  global_position - player.global_position
		z.y = 0
		z = z.normalized()
	var y = Vector3.UP
	var x = y.cross(z).normalized()
	var new_basis = Basis(x, y, z).orthonormalized()
	global_basis = global_basis.slerp(new_basis, 0.1)
	
	if abs(velocity) > Vector3(0.1,0.1,0.1):
		animState.travel("Wraith_Movement")
	else:
		animState.travel("Wraith_Idle")


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
