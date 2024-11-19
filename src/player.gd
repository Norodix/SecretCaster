extends CharacterBody3D

# facing angle in radians relative to facing the -z direction
var facing_angle = 0.0
var tilt = 0.0
var speed = 7
var vh_damping = 0.9
var vh_acc = 100
var mousespeed = 0.001

var action_history = PackedStringArray()
var historysize = 10

var activespell = null
const cooldown_time_ms_default = 2000
var cooldown_time_ms = cooldown_time_ms_default
var last_activate = - cooldown_time_ms_default * 1000

@onready var playerAnim : AnimationTree = $Camera3D/Magic_Hands/AnimationTree
@onready var playerAnimState = $Camera3D/Magic_Hands/AnimationTree.get("parameters/StateMachine/playback")
@onready var pistolAnimState = $Camera3D/Magic_Hands/Armature/Skeleton3D/BoneAttachment3D2/colt/AnimationTree.get("parameters/playback")
@onready var pistol = $Camera3D/Magic_Hands/Armature/Skeleton3D/BoneAttachment3D2/colt
@onready var hud = $HUD

var pistol_trail = preload("res://Colt/TrailRender.tscn")

enum ATTACK_MODE {
	PISTOL,
	MAGIC,
	MAX, # must be last and unused
}
var attack_mode = ATTACK_MODE.MAGIC

const bullet_count = 7
var bullets = bullet_count

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Pistol_Visibility_Timer.wait_time =  playerAnim.get_animation("Hands_Swap").length / 2.0

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
	
	if velocity.length() > 0.1:
		playerAnim.set("parameters/MotionBlend/blend_amount", velocity.length() * 0.1)
	
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
				activate_spell(spell)
	
	if attack_mode == ATTACK_MODE.MAGIC:
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
				playerAnimState.travel("Hands_Magic_Cast")
	
	if attack_mode == ATTACK_MODE.PISTOL:
		if Input.is_action_just_pressed("use_spell"):
			shoot_pistol()
		if Input.is_action_just_pressed("reload"):
			reload_pistol()
			
	if Input.is_action_just_pressed("attack_mode"):
		attack_mode = (attack_mode + 1) % ATTACK_MODE.MAX
		if attack_mode == ATTACK_MODE.MAGIC:
			playerAnimState.travel("Hands_Magic_Idle")
		if attack_mode == ATTACK_MODE.PISTOL:
			playerAnimState.travel("Hands_Pistol_Idle")
		$Pistol_Visibility_Timer.start()
		hud.set_active_mode(attack_mode)
	return


func activate_spell(spell : Node):
	activespell = spell
	print("Selecting: " + spell.name)
	hud.select(spell)


func pistol_busy():
	if not $Pistol_Shoot_Cooldown.is_stopped():
		return true
	if not $Pistol_Reload_Cooldown.is_stopped():
		return true
	return false

# Bingibungel shoots the pistol in the comment
func shoot_pistol():
	if bullets == 0:
		print("Bangol says haha")
		# Play clicky sound
		return
	if pistol_busy():
		return
	if bullets == 1:
		bullets -= 1
		pistolAnimState.travel("colt_empty")
		playerAnimState.travel("Hands_Pistol_Fire")
		return
	bullets -= 1
	pistolAnimState.travel("colt_shoot")
	playerAnimState.travel("Hands_Pistol_Fire")
	$Pistol_Shoot_Cooldown.start()
	
	# Do the hitscan stuff
	var trail_start = pistol.find_child("Particle_Muzzle").global_position
	var trail_end
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var camera = get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	trail_end = to
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = 1 | 1 << 3
	var raycast_result = space.intersect_ray(ray_query)
	if not raycast_result.is_empty():
		#print(raycast_result.collider)
		var body = raycast_result.collider
		if body.has_method("damage"):
			body.damage("colt")
		trail_end = raycast_result.position
	# draw pistol trail
	var pt = pistol_trail.instantiate()
	pt.start = trail_start
	pt.end = trail_end
	get_tree().root.add_child(pt)
	pt.global_basis = camera.global_basis


# Bingibungel reloads using a comment
func reload_pistol():
	if pistol_busy():
		return
	if bullets > 0:
		pistolAnimState.travel("colt_reload")
		playerAnimState.travel("Hands_Pistol_Reload")
		bullets = bullet_count + 1
	else:
		pistolAnimState.travel("RESET")
		playerAnimState.travel("Hands_Pistol_Reload_Empty")
		bullets = bullet_count
	$Pistol_Reload_Cooldown.start()
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


func _on_timer_timeout() -> void:
	if attack_mode == ATTACK_MODE.PISTOL:
		pistol.visible = true
	else:
		pistol.visible = false
	pass # Replace with function body.
