extends CharacterBody3D
class_name Player

const SPEED = 7.5
const SPRINT_SPEED = 11.25
const JUMP_VELOCITY = 9
const SENSITIVITY = 0.1
const ACCELERATION = 60.0
@onready var head: Node3D = $Head


func _ready() -> void:
	Assign_Weapon()

func Normal_Camera(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-15,25)

func Normal_Movement(delta : float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0.0 , input_dir.y)).normalized()
	if direction:
		var speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
		velocity = velocity.move_toward(Vector3(direction.x * speed, velocity.y, direction.z * speed), delta * ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector3(0.0,velocity.y,0.0), delta * ACCELERATION)

	move_and_slide()
	
	

func Assign_Weapon():
	var weapon = load(allweapons.STICK).instantiate()
	Player_Statistics.equipedweapon = weapon
