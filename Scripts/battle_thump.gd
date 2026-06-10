extends Combatant

var health = 50
var spot : Marker3D
var speed = 8
const NAME = "Thump"
const DAMAGE = 20
var jumping = false
var my_turn
@onready var trauma = 0.4
@onready var turn_timer: Timer = $Turn_Timer
@onready var attack_container: Node3D = $"../../Attack_Container"
@onready var feet: Marker3D = $Feet
var ripple = preload("uid://2oqn8hwjkgu3").instantiate()

func onload():
	spot = get_parent()
	my_turn = false

func _physics_process(delta: float) -> void:
	if health <= 0:
		Scene_Switcher.load_freeroam(Arena_Result.new(true))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if jumping:
		ripple.jumping(self)
	
	move_and_slide()

func playerturn():
	my_turn = false
	look_at(player.global_position)
	rotation_degrees.x = 0

func enemyturn():
	my_turn = true
	await get_tree().create_timer(1.0).timeout
	turn_timer.start()
	attack()

func attack():
	Jump()

func Jump():
	jumping = false
	await get_tree().create_timer(1.0).timeout
	if my_turn:
		ripple.jump_start(self)
		jumping = true

func _on_bottom_box_body_entered(body: Node3D) -> void:
	ripple.jump_end(self,body,DAMAGE)
	player.camera.add_trauma(trauma)


func _on_turn_timer_timeout() -> void:
	jumping = false
	global_position = spot.global_position
	velocity = Vector3.ZERO
	arena.Next_Turn()
