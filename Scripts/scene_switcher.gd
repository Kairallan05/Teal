extends Node

const ARENA = preload("uid://c26u00tau1tqb")
const DEMO_WORLD = preload("uid://b2b63svucmv1d")
var deadenemies : Array[StringName]
var current_scene
var combatant_name : StringName

func _ready() -> void:
	var root = get_tree().root
	current_scene = root.get_child(-1)

func load_arena(config:Arena_Config):
	_deferred_load_arena.call_deferred(config)

func _deferred_load_arena(config:Arena_Config):
# Replace freeroam scene with arena scene
	current_scene.free()
	current_scene = ARENA.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
# apply configuration to the arena scene
	combatant_name = config.combatant_name
	var combatant = config.combatant.instantiate()
	current_scene.get_node("Enemy_Spot").add_child(combatant)
	current_scene.onload()
	current_scene.get_node("Player_Spot/Battle_Player").onload()
	current_scene.get_node("Enemy_Spot").get_child(0).onload()

func load_freeroam(result:Arena_Result):
	_deferred_load_freeroam.call_deferred(result)

func _deferred_load_freeroam(result:Arena_Result):
	current_scene.free()
	current_scene = DEMO_WORLD.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
# apply configuration to the Freeroam scene
	if result.Victory:
		deadenemies.push_back(combatant_name)
	for deadenemy in deadenemies:
		for enemy in current_scene.get_node("Enemies").get_children():
			if enemy.name == deadenemy:
				enemy.queue_free()
