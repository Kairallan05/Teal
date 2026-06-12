extends Node

var t
var origin
var target
var midpoint
var trauma = 0.2

func jump_start(user):
	user.look_at(user.player.global_position)
	t = 0.0
	origin = user.global_position
	target = user.player.global_position
	midpoint = (origin + target)/2
	midpoint.y += 5

func jumping(user):
	var start = origin.lerp(midpoint, t)
	var end = midpoint.lerp(target, t)
	var curve = start.lerp(end, t)
	t += 0.04
	user.global_position = curve

func jump_end(user,hit,damage):
	if user.jumping:
		if hit.is_in_group("floor"):
			user.attack()
			var Ripple = preload("uid://ccl0u5ljqusv2").instantiate()
			Ripple.damage = damage
			Ripple.size = 20.0
			Ripple.speed = 5.0
			user.attack_container.add_child(Ripple)
			Ripple.global_position = user.feet.global_position
		if hit.is_in_group("player"):
			Player_Statistics.health -= damage
			user.player.camera.add_trauma(trauma)
			hit.velocity += origin.direction_to(hit.global_position).normalized() * 25
			hit.velocity.y += 5
