extends CharacterBody3D

var target = Vector3.ZERO
var speed = 7
var health = 10
var acceleration = 30
@onready var player = get_tree().root.find_child("Player", true, false)
var strafe_direction = randi() % 2

var model : Node3D
var capedrop : PackedScene
var animState : AnimationNodeStateMachinePlayback
var swordAreas : Array[Area3D]
var has_hit = false # indicates if the sword has hit the player in this swing


# Select a random wraith model to use, free the others
func select_model():
	if randf() > 0.5:
		# Claws
		model = $Wraith_Claws2
		$Wraith_Model.queue_free()
		capedrop = load("res://Wraith_Claws/wraith_claws_cape_drop.tscn")
	else:
		# Swordsd
		model = $Wraith_Model
		$Wraith_Claws2.queue_free()
		capedrop = load("res://Wraith/wraith_cape_drop.tscn")


func _ready() -> void:
	$NavigationTimer.wait_time = randf()
	select_model()
	animState = model.get_node("AnimationTree").get("parameters/StateMachine/playback")
	for child in model.find_children("*SwordArea*"):
		if child is Area3D:
			swordAreas.append(child)

# behavior state machine
var states = {
	"idle" = { # name of the state
		"time" = 1.0, # reevaluation time
		"next" = [ # possible next states and weights
			{ "name" = "direct", "weight" = 0.1},
		]
	},
	"direct" = { # name of the state
		"time" = 0.2, # reevaluation time
		"next" = [ # possible next states and weights
			{ "name" = "direct", "weight" = 0.1},
			{ "name" = "strafe", "weight" = 0.1},
			{ "name" = "attack", "weight" = 0.9},
			{ "name" = "flee"  , "weight" = 0.0},
		]
	},
	"strafe" = { # name of the state
		"time" = 0.2, # reevaluation time
		"next" = [ # possible next states and weights
			{ "name" = "direct", "weight" = 0.1},
			{ "name" = "strafe", "weight" = 0.1},
			{ "name" = "attack", "weight" = 0.9},
			{ "name" = "flee"  , "weight" = 0.0},
		]
	},
	"attack" = { # name of the state
		"time" = 1.8, # reevaluation time, must match attack animation
		"next" = [ # possible next states and weights
			{ "name" = "direct", "weight" = 0.4},
			{ "name" = "strafe", "weight" = 0.4},
			{ "name" = "flee"  , "weight" = 0.0},
		]
	},
	"flee" = { # name of the state
		"time" = 1.0, # reevaluation time
		"next" = [ # possible next states and weights
			{ "name" = "direct", "weight" = 0.5},
			{ "name" = "strafe", "weight" = 0.5},
			{ "name" = "flee"  , "weight" = 0.0},
		]
	},
}
var state = "idle"


func damage(value : float, type : String):
	var val = value
	match type:
		"fire":
			val *= 2
		"shock":
			val *= 1.5
	health -= val
	if not $AudioStreamPlayer3D_Damage.playing:
		$AudioStreamPlayer3D_Damage.play()
	if health <= 0:
		destroy()


var is_destroying = false # lock out, sometimes it was possible to call this multiple times
func destroy():
	if is_destroying:
		return
	is_destroying = true
	trigger_state_transisiton("idle")
	$NavigationTimer.stop()
	animState.next()
	animState.travel("Wraith_Idle")
	model.visible = false
	var instance = capedrop.instantiate()
	self.add_child(instance)
	instance.basis = Basis.IDENTITY.rotated(Vector3.UP, deg_to_rad(180))
	$CollisionShape3D.set_deferred("disabled", true)
	$AudioStreamPlayer3D_Death.play()
	await $AudioStreamPlayer3D_Death.finished
	self.queue_free()


# called once when the agent enters the attack state
func attack():
	has_hit = false
	# Clears the travel between idle and movement when it is currently in progress
	# This is necessary to make sure the attack animation plays in time
	animState.next()
	animState.travel("Wraith_Attack")


func _physics_process(delta: float) -> void:
	if health <= 0:
		return
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
	v.y = 0 # fix downwards movement singularity
	if v.length() > 0.1:
		z = - v
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
	if global_basis.x == Vector3.ZERO:
		pass
	if new_basis.x == Vector3.ZERO:
		pass
	var offset = global_position - player.global_position
	if state == "direct" and offset.length() < 3:
		trigger_state_transisiton("attack")
	if state == "attack":
		# Check if the sword has hit the player
		for swordArea in swordAreas:
			var bodies = swordArea.get_overlapping_bodies()
			for body in bodies:
				if body.has_method("damage") and not has_hit:
					body.damage()
					has_hit = true


func random_with_weights(possiblities : Array):
	var cumweights : Array[float]
	for p in possiblities:
		cumweights.append(p["weight"])
	for i in range(1, cumweights.size()):
		cumweights[i] += cumweights[i-1]
	var f = randf() * cumweights[-1]
	for i in range(cumweights.size()):
		if cumweights[i] >= f:
			return possiblities[i]["name"]


# Trigger state transition to specific state
# If not specified, a random state is returned based on the state transition table's weights
func trigger_state_transisiton(to : String = ""):
	if health <= 0:
		state = "idle"
		return
	var newstate : String
	if to == "":
		var next_possible : Array = states[state]["next"]
		newstate = random_with_weights(next_possible)
	else:
		newstate = to
	#print(state, " -> ", newstate)
	state = newstate
	if state == "attack":
		var offset = global_position - player.global_position
		if offset.length() > 3:
			state = "direct"
		else:
			attack()
	if state == "strafe":
		strafe_direction = randi() % 2
	$StateTimer.stop()
	$StateTimer.start(states[state]["time"])


func _on_navigation_timer_timeout() -> void:
	if not player:
		var root = get_tree().root
		player = root.find_child("Player", true, false)
		return
	# select new strategy
	# the next possible states

	var offset = global_position - player.global_position
	match state:
		"idle":
			animState.travel("Wraith_Idle")
		"direct":
			$NavigationAgent3D.target_position = player.global_position
			animState.travel("Wraith_Movement")
		"flee":
			$NavigationAgent3D.target_position = player.global_position + offset.normalized() * 10
			animState.travel("Wraith_Movement")
		"strafe":
			var sidestep = offset.normalized().rotated(Vector3.UP, PI/2) * 10
			if strafe_direction:
				sidestep *= -1
			$NavigationAgent3D.target_position = player.global_position + sidestep
			animState.travel("Wraith_Movement")
		"attack":
			$NavigationAgent3D.target_position = player.global_position
		_:
			pass


func _on_state_timer_timeout() -> void:
	trigger_state_transisiton()
	pass # Replace with function body.
