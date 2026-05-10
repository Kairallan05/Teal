extends Weapon

func _init() -> void:
	base_damage = 5

func basic_attack(enemy : Combatant):
	print(base_damage)
	enemy.health -= base_damage
