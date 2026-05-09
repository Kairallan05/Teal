extends Node

var user
var move_speed
var hit
var target
var damage

func move(user,move_speed,damage):
	user.velocity = target * move_speed
	if user.raycast.is_colliding():
		var collider = user.raycast.get_collider()
		if collider is Node:
			if collider.is_in_group("Wall"):
				user.attack()
			if collider.is_in_group("player"):
				if !hit:
					Player_Statistics.health -= damage
					collider.velocity += user.velocity * 1.5
					collider.velocity.y += 7.5
					hit = true

func Charge_Start(user):
	hit = false
	user.look_at(user.player.global_position)
	user.rotation_degrees.x = 0
	var direction = Vector3(user.player.global_position.x - user.global_position.x, 0, user.player.global_position.z - user.global_position.z)
	target = direction.normalized()
