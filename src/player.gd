extends CharacterBody3D

# facing angle in radians relative to facing the -z direction
var facing_angle = 0.0
var tilt = 0.0
var speed = 5
var vh_damping = 0.9
var vh_acc = 100
var mousespeed = 0.001

var action_history = PackedStringArray()
var historysize = 10

var activespell = null
const cooldown_time_ms_default = 2000
var cooldown_time_ms = cooldown_time_ms_default
var last_activate = - cooldown_time_ms_default * 1000

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	var inputvector = Input.get_vector("left", "right", "forwards", "backwards")
	var vy = velocity.y
	var vh = velocity - Vector3(0, vy, 0)
	
	vy -= 10 * delta # gravity
	vy *= 0.9999
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		vy += 5
	
	if inputvector.length() < 0.1:
		vh *= vh_damping
	var input_move_vec = Vector3(inputvector.x, 0, inputvector.y).rotated(Vector3.UP, facing_angle)
	vh += input_move_vec * vh_acc * delta
	vh = vh.limit_length(speed)
	
	velocity = vh + Vector3(0, vy, 0)
	move_and_slide()
	return


func _process(delta: float) -> void:
	var b = Basis()
	b = b.rotated(Vector3.UP, facing_angle)
	b = b.rotated(b.x, tilt)
	$Camera3D.basis = b
	
	for spell in $Spells.get_children():
		if match_action_history(spell.pattern):
			if spell != activespell:
				activespell = spell
				print("Selecting: " + spell.name)
	
	if Input.is_action_just_pressed("use_spell") and activespell != null:
		if Time.get_ticks_msec() < last_activate + cooldown_time_ms:
			print("Spells on cooldown")
		else:
			if activespell.has_method("use_spell"):
				activespell.use_spell(self)
				last_activate = Time.get_ticks_msec()
				if "cooldown" in activespell:
					cooldown_time_ms = activespell.cooldown
				else:
					cooldown_time_ms = cooldown_time_ms_default
			
	return


# Check if the action history's last actions match the given pattern
# Only the last actions are checked, any new action invalidates the pattern
# eg. match_action_history(["right", "left", "right", "right"])
func match_action_history(pattern: PackedStringArray):
	if pattern.size() < 1 or pattern.size() > historysize:
		return false
	if pattern.size() > action_history.size():
		return false
	var ps = pattern.size()
	for i in ps:
		var ai = action_history.size() - i - 1
		var pi = ps - i - 1
		if action_history[ai] != pattern[pi]:
			return false
	return true


# Look for the first occurence of the specified event in the action map
func get_action_from_event(event: InputEvent):
	var actions = InputMap.get_actions()
	for a in actions:
		if InputMap.action_has_event(a, event):
			return a
	return null


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#print(event.relative)
		#print(tilt)
		facing_angle += event.relative.x * mousespeed * -1
		tilt += event.relative.y * mousespeed * -1
		var maxtilt = 0.9 * PI * 0.5
		tilt = clamp(tilt, -maxtilt, maxtilt)
	if event.is_action_type() and event.is_pressed() and not event.is_echo():
		#print(event.action)
		var action = get_action_from_event(event)
		if action:
			#print(action)
			action_history.append(action)
			if action_history.size() > historysize:
				action_history.remove_at(0)
		#print(action_history)
