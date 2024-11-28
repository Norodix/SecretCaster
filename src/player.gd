extends CharacterBody3D

# facing angle in radians relative to facing the -z direction
var facing_angle = 0.0
var tilt = 0.0
var speed = 7
var crouch_speed = 5
var vh_damping = 0.9
var vh_acc = 100
var mousespeed = 0.001
var health = 100
var crouching = false

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
@onready var handspell_parent = $Camera3D/Magic_Hands/Armature/Skeleton3D/BoneAttachment3D

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
	if global_position.y < -50:
		defeat()
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
	# select speed based on player state
	var s = crouch_speed if crouching else speed
	vh = vh.limit_length(s)
	
	velocity = vh + Vector3(0, vy, 0)
	
	if velocity.length() > 0.1:
		playerAnim.set("parameters/MotionBlend/blend_amount", velocity.length() * 0.1)
	
	move_and_slide()
	return


func _process(delta: float) -> void:
	parse_controller_camera()
	var b = Basis()
	b = b.rotated(Vector3.UP, facing_angle)
	b = b.rotated(b.x, tilt)
	$Camera3D.basis = b
	
	for spell in $Spells.get_children():
		if match_action_history(spell.pattern):
			if spell != activespell:
				activate_spell(spell)
	
	if Input.is_action_pressed("crouch"):
		crouching = true
	else:
		var bodies = $Area3D_Head.get_overlapping_bodies()
		if bodies.is_empty():
			crouching = false
	
	if crouching:
		$Camera3D.position.y = lerp($Camera3D.position.y, 0.45, 0.5)
		$CollisionShape3D_Head.disabled = true
	else:
		$Camera3D.position.y = lerp($Camera3D.position.y, 0.85, 0.5)
		$CollisionShape3D_Head.disabled = false
	
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


func parse_controller_camera():
	# Camera handling for controller
	var sensitivity = 0.05
	var vec = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down") * -1
	tilt += vec.y * sensitivity
	facing_angle += vec.x * sensitivity
	pass


func activate_spell(spell : Node):
	activespell = spell
	print("Selecting: " + spell.name)
	hud.select(spell)
	for child in handspell_parent.get_children():
		child.visible = false
	if "hand_name" in spell:
		var handspell = handspell_parent.find_child(spell.hand_name)
		handspell.visible = true


func pistol_busy():
	if not $Pistol_Shoot_Cooldown.is_stopped():
		return true
	if not $Pistol_Reload_Cooldown.is_stopped():
		return true
	return false


func damage(hit : float = 10, type : String = "physical"):
	if not $Damage_Cooldown.is_stopped():
		# Player cannot be damaged so quickly again
		print("damage on cooldown")
		return
	print("damage")
	self.health -= hit
	$Damage_Cooldown.start()
	$HUD.damage()
	$AudioStreamPlayer3D_Damage.play()
	find_child("Healthbar").value = health # TODO ugly
	if health <= 0:
		defeat()


func defeat():
	get_tree().change_scene_to_file("res://Menu/MainMenu.tscn")


# Bingibungel shoots the pistol in the comment
func shoot_pistol():
	if pistol_busy():
		return
	if bullets == 0:
		print("Bangol says haha")
		# Play clicky sound
		pistol.find_child("AudioStreamPlayer3D_Click", true, false).play()
		return
	bullets -= 1
	playerAnimState.travel("Hands_Pistol_Fire")
	pistol.find_child("AudioStreamPlayer3D_Shoot", true, false).play()
	if bullets == 0:
		pistolAnimState.travel("colt_lastshot")
		pistol.find_child("AudioStreamPlayer3D_Empty", true, false).play()
	else:
		pistolAnimState.travel("colt_shoot")
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
			body.damage(1, "colt")
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
	pistolAnimState.travel("RESET")
	playerAnimState.travel("Hands_Pistol_Reload")
	pistol.find_child("AudioStreamPlayer3D_Reload", true, false).play()
	if bullets == 0:
		bullets = bullet_count
	else:
		bullets = bullet_count + 1
	$Pistol_Reload_Cooldown.start()
	return


# return the fraction (0-1) of how much of the cooldown period passed already
func get_cooldown_fraction() -> float:
	var t = Time.get_ticks_msec()
	return float(t - last_activate) / cooldown_time_ms


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
		if "ui_" in a:
			continue
		if InputMap.action_has_event(a, event):
			#print("action found: ", a)
			return a
	#print("no matching action found for event: ", event)
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
		#print(event.get_action_strength(action))
		if action:
			# Append only if the joystick fully moves to a direction
			if event.get_action_strength(action) != 1.0:
				return
			# Filter out camera actions, since they only happen on controller
			if "cam_" in action:
				return
			print(action)
			action_history.append(action)
			if action_history.size() > historysize:
				action_history.remove_at(0)


func _on_timer_timeout() -> void:
	if attack_mode == ATTACK_MODE.PISTOL:
		pistol.visible = true
	else:
		pistol.visible = false
	pass # Replace with function body.
