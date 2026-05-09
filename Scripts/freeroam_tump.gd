extends CharacterBody3D

const SPEED = 5
const CATCHDISTANCE = 2
const BATTLE_TUMP = preload("uid://cajv4afrhgx57")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../../Freeroam_Player"

func _process(delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position

func _physics_process(delta: float) -> void:
	var next_path = navigation_agent_3d.get_next_path_position()
	global_position = global_position.move_toward(next_path, delta * SPEED)
	if (player.global_position - global_position).length() < CATCHDISTANCE:
		Scene_Switcher.load_arena(Arena_Config.new(BATTLE_TUMP,name))
