extends CharacterBody3D

const SPEED = 7
const CATCHDISTANCE = 2
const CHASEDISTANCE = 20
const BATTLE_THUMP = preload("uid://bhn38kmkg3qp7")
const GRASS_ARENA = preload("uid://db30o6ccxlpue")

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../../Freeroam_Player"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position
	

func _physics_process(delta: float) -> void:
	var next_path = navigation_agent_3d.get_next_path_position()
	
	if (player.global_position - global_position).length() < CHASEDISTANCE:
		global_position = global_position.move_toward(next_path, delta * SPEED)
		if next_path != global_position:
			look_at(next_path)
		else:
			look_at(Vector3(player.global_position.x,0.0,player.global_position.z))
			rotation_degrees.x = 0.0
	else:
		rotation_degrees.x = 0.0
		pass
	if (player.global_position - global_position).length() < CATCHDISTANCE:
		Scene_Switcher.load_arena(Arena_Config.new(BATTLE_THUMP,name,GRASS_ARENA))
