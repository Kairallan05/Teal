extends CharacterBody3D
class_name Combatant
@onready var arena: Arena = $"../.."
var player : Player

func _ready() -> void:
	arena.playerturn.connect(playerturn)
	arena.enemyturn.connect(enemyturn)

func playerturn():
	pass

func enemyturn():
	pass
