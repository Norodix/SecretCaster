extends CharacterBody3D

# facing angle in radians relative to facing the -z direction
var facing_angle = 0.0
var tilt = 0.0
var speed = 5
var vh_damping = 0.9
var vh_acc = 100
var mousespeed = 0.001

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _physics_process(delta: float) -> void:
	var inputvector = Input.get_vector("left", "right", "forwards", "backwards")
	var vy = velocity.y
	var vh = velocity - Vector3(0, vy, 0)
	
	vy -= 10 * delta # gravity
	vy *= 0.9999
	
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
	return
	var facing = Vector3(0, 0, -1).rotated(Vector3.UP, facing_angle)
	var right = Vector3(1, 0, 0).rotated(Vector3.UP, facing_angle)
	facing = facing.rotated(right, tilt)
	var up = Vector3(0, 1, 0).rotated(right, tilt)
	$Camera3D.basis.x = right
	$Camera3D.basis.y = up
	$Camera3D.basis.z = -facing
	$Camera3D.basis

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print(event.relative)
		print(tilt)
		facing_angle += event.relative.x * mousespeed * -1
		tilt += event.relative.y * mousespeed * -1
		var maxtilt = 0.9 * PI * 0.5
		tilt = clamp(tilt, -maxtilt, maxtilt)
		
