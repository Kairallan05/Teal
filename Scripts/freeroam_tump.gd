extends CharacterBody3D

const SPEED = 5
const CATCHDISTANCE = 2
const BATTLE_TUMP = preload("uid://cajv4afrhgx57")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var player: CharacterBody3D = $"../../Freeroam_Player"
@onready var animated_sprite_3d: AnimatedSprite3D = $Tump/Armature/Skeleton3D/BoneAttachment3D/AnimatedSprite3D
@onready var animation_player: AnimationPlayer = $Tump/AnimationPlayer

func _ready() -> void:
	animated_sprite_3d.play("Face")
	animation_player.play("Armature|charge")

func _process(delta: float) -> void:
	navigation_agent_3d.target_position = player.global_position
	look_at(Vector3(player.global_position.x,0,player.global_position.z))

func _physics_process(delta: float) -> void:
	var next_path = navigation_agent_3d.get_next_path_position()
	global_position = global_position.move_toward(next_path, delta * SPEED)
	if (player.global_position - global_position).length() < CATCHDISTANCE:
		Scene_Switcher.load_arena(Arena_Config.new(BATTLE_TUMP,name))
