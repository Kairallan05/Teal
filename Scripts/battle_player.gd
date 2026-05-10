extends Player

var my_turn = false
@onready var arena: Arena = $"../.."
@onready var camera: Camera3D = $Head/SpringArm3D/Camera
var opponent : Combatant

func onload():
	pass

func _unhandled_input(event):
	if my_turn:
		pass
	else:
		Normal_Camera(event)

func _physics_process(delta: float) -> void:
	if Player_Statistics.health <= 0:
		Player_Statistics.health = Player_Statistics.maxhealth
		Scene_Switcher.load_freeroam(Arena_Result.new(false))
	
	if Input.is_action_just_pressed("interact"):
		if my_turn:
			arena.Next_Turn()
			Player_Statistics.equipedweapon.basic_attack(opponent)
	if my_turn:
		pass
	else:
		Normal_Movement(delta)


func playerturn() -> void:
	my_turn = true
	arena.battle_camera.make_current()
	position = Vector3.ZERO
	rotation = Vector3(0,deg_to_rad(90),0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func enemyturn() -> void:
	my_turn = false
	camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
