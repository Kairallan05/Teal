extends Combatant

var health = 50
var spot : Marker3D
var speed = 8
const NAME = "Thump"
const DAMAGE = 20
var jumping = false
var spinning = false
var my_turn
@onready var trauma = 0.4
@onready var turn_timer: Timer = $Turn_Timer
@onready var spin_timer: Timer = $Spin_Timer
@onready var attack_container: Node3D = $"../../Attack_Container"
@onready var feet: Marker3D = $Feet
var ripple = preload("uid://2oqn8hwjkgu3").instantiate()
var spin = preload("uid://603il7q3a821").instantiate()
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
	if spinning:
		spin.spinning(delta)
	
	move_and_slide()

func playerturn():
	my_turn = false
	look_at(player.global_position)
	rotation_degrees.x = 0

func enemyturn():
	my_turn = true
	await get_tree().create_timer(1.0).timeout
	turn_timer.start()
	[Spin_attack,Jump].pick_random().call()

func attack():
	if spinning:
		Spin_attack()
	if jumping:
		Jump()

func Jump():
	jumping = false
	await get_tree().create_timer(1.0).timeout
	if my_turn:
		ripple.jump_start(self)
		jumping = true

func Spin_attack():
	spin.Spin_start(self,DAMAGE)
	spinning = true

func _on_bottom_box_body_entered(body: Node3D) -> void:
	ripple.jump_end(self,body,DAMAGE)
	player.camera.add_trauma(trauma)


func _on_turn_timer_timeout() -> void:
	if spinning:
		spin_timer.stop()
	jumping = false
	spinning = false
	global_position = spot.global_position
	velocity = Vector3.ZERO
	arena.Next_Turn()


func _on_spin_timer_timeout() -> void:
	spin.Launch()
