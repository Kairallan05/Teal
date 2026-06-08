extends Weapon

func _init() -> void:
	base_damage = 10

func basic_attack(enemy : Combatant):
	enemy.health -= base_damage
