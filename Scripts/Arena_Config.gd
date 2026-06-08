extends Resource
class_name Arena_Config

var combatant : Resource
var combatant_name : StringName
var arena_mesh : PackedScene
  
func _init(new_combatant,new_combatant_name,new_arena_mesh) -> void:
	combatant = new_combatant
	combatant_name = new_combatant_name
	arena_mesh = new_arena_mesh
