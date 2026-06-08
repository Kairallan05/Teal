extends CharacterBody3D
class_name Player

const SPEED = 7.5
const SPRINT_SPEED = 11.25
const JUMP_VELOCITY = 9
const SENSITIVITY = 0.1
const ACCELERATION = 60.0
var speed = 0.0
var falling = false
@onready var head: Node3D = $Head
@onready var player_model: Node3D = $Player_model
@onready var animation_player: AnimationPlayer = $Player_model/AnimationPlayer


func _ready() -> void:
	Assign_Weapon()

func Normal_Camera(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		player_model.rotate_y(deg_to_rad(event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation_degrees.x = clamp(head.rotation_degrees.x,-15,25)

func Normal_Movement(delta : float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		falling = true
	if is_on_floor():
		falling = false
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0.0 , input_dir.y)).normalized()
	if direction:
		speed = SPRINT_SPEED if Input.is_action_pressed("sprint") else SPEED
		var local_velocity = velocity * transform.basis
		var target_angle = atan2(local_velocity.x, local_velocity.z)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, target_angle, delta * 10)
		player_model.rotation_degrees.x = 0.0
		velocity = velocity.move_toward(Vector3(direction.x * speed, velocity.y, direction.z * speed), delta * ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector3(0.0,velocity.y,0.0), delta * ACCELERATION)

	move_and_slide()
	
	
	if (velocity.x or velocity.z != 0.0) and !falling:
		if speed == SPRINT_SPEED:
			animation_player.play("Sprint")
		if speed == SPEED:
			animation_player.play("Run")
	elif !falling:
		animation_player.play("Idle")
	elif falling:
		animation_player.play("Fall")


func Assign_Weapon():
	var weapon = load(allweapons.STICK).instantiate()
	Player_Statistics.equipedweapon = weapon
