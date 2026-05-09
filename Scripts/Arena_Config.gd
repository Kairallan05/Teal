extends Resource
class_name Arena_Config

var combatant : Resource
var combatant_name : StringName
  
func _init(new_combatant,new_combatant_name) -> void:
	combatant = new_combatant
	combatant_name = new_combatant_name
