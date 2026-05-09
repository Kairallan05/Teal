extends Combatant

var health = 40
var spot : Marker3D
var speed = 15
const NAME = "Tump"
const DAMAGE = 15
@onready var turn_timer: Timer = $Turn_Timer
@onready var raycast: RayCast3D = $Raycast
var charge = preload("uid://ds7s66p7tn81s").instantiate()
var jump = preload("uid://drwy4486e1s7h").instantiate()
var charging = false
var jumping = false

func onload():
	spot = get_parent()

func _physics_process(delta: float) -> void:
	if health <= 0:
		Scene_Switcher.load_freeroam(Arena_Result.new(true))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if charging:
		charge.move(self,speed,DAMAGE)
	if jumping:
		jump.jumping(self)
	move_and_slide()

func playerturn():
	look_at(player.global_position)
	rotation_degrees.x = 0

func enemyturn():
	await get_tree().create_timer(1.0).timeout
	turn_timer.start()
	[Charge,Jump].pick_random().call()

func _on_turn_timer_timeout() -> void:
	charging = false
	jumping = false
	global_position = spot.global_position
	velocity = Vector3.ZERO
	arena.Next_Turn()

func attack():
	if health <= 20:
		[Charge,Jump].pick_random().call()
	else:
		if charging:
			Charge()
		if jumping:
			Jump()

func Charge():
	charge.Charge_Start(self)
	charging = true
	jumping = false

func Jump():
	jump.jump_start(self)
	charging = false
	jumping = true


func _on_bottom_box_body_entered(body: Node3D) -> void:
	jump.jump_end(self,body,DAMAGE)
