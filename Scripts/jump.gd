extends Node

var user
var t
var origin
var target
var midpoint

func jump_start(user):
	user.look_at(user.player.global_position)
	t = 0.0
	origin = user.global_position
	target = user.player.global_position
	midpoint = (origin + target)/2
	midpoint.y += 15

func jumping(user):
	var start = origin.lerp(midpoint, t)
	var end = midpoint.lerp(target, t)
	var curve = start.lerp(end, t)
	t += 0.01
	user.global_position = curve

func jump_end(user,hit,damage):
	if user.jumping:
		if hit.is_in_group("floor"):
			user.attack()
		if hit.is_in_group("player"):
			Player_Statistics.health -= damage
			hit.velocity += origin.direction_to(hit.global_position).normalized() * 25
			hit.velocity.y += 5
