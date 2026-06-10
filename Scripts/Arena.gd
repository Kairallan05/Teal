extends Node3D
class_name Arena

@onready var battle_camera: Camera3D = $Battle_Camera
@onready var battle_player: CharacterBody3D = $Player_Spot/Battle_Player
@onready var enemy_spot: Marker3D = $Enemy_Spot
@onready var enemy_health: TextureProgressBar = $Battle_UI/Control/Enemy_health
@onready var attack_container: Node3D = $Attack_Container
var Enemy : Combatant

enum Turn{player,enemy}
var turn := Turn.player
signal playerturn()
signal enemyturn()


func _process(_delta: float) -> void:
	enemy_health.value = Enemy.health

func onload() -> void:
	Enemy = enemy_spot.get_child(0)
	battle_player.opponent = Enemy
	Enemy.player = battle_player
	enemy_health.max_value = Enemy.health
	playerturn.emit()

func Next_Turn():
	match turn:
		Turn.player:
			turn = Turn.enemy
			enemyturn.emit()
		Turn.enemy:
			turn = Turn.player
			playerturn.emit()
			for n in attack_container.get_children():
				n.queue_free()
