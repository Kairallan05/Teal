extends Player


var my_turn = false
@onready var arena: Arena = $"../.."
@onready var camera: Camera3D = $Head/SpringArm3D/Camera
@onready var attacks: AnimatedSprite2D = $UI/Control/Spriteholder/Attacks
@onready var ui_back: TextureRect = $UI/Control/UiBack
@onready var attack_button: TextureButton = $UI/Control/UiBack/Attack_button
@onready var player_health: TextureProgressBar = $UI/Control/UiBack/PlayerHealth
var opponent : Combatant


func onload():
	attacks.visible = false

func _unhandled_input(event):
	if my_turn:
		pass
	else:
		Normal_Camera(event)

func _physics_process(delta: float) -> void:
	
	player_health.max_value = Player_Statistics.maxhealth
	player_health.value = Player_Statistics.health
	
	if Player_Statistics.health <= 0:
		Player_Statistics.health = Player_Statistics.maxhealth
		Scene_Switcher.load_freeroam(Arena_Result.new(false))
	

	if my_turn:
		if not is_on_floor():
			velocity += get_gravity() * delta
		animation_player.play("Fight_idle")
		move_and_slide()
	else:
		Normal_Movement(delta)


func playerturn() -> void:
	my_turn = true
	ui_back.visible = true
	attack_button.visible = true
	arena.battle_camera.make_current()
	position = Vector3.ZERO
	velocity = Vector3.ZERO
	rotation_degrees.y = 0
	player_model.rotation_degrees.y = 180
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func enemyturn() -> void:
	my_turn = false
	ui_back.visible = false
	attack_button.visible = false
	get_viewport().gui_release_focus()
	camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_attacks_animation_finished() -> void:
	attacks.visible = false
	arena.Next_Turn()
	Player_Statistics.equipedweapon.basic_attack(opponent)


func _on_attack_button_pressed() -> void:
	attacks.visible = true
	attacks.play("Sword_Slice")
