extends Node

var damage
var user

func Spin_start(use,dam):
	damage = dam
	user = use
	use.spin_timer.start()

func spinning(delta):
	user.global_position.x = move_toward(user.global_position.x, 0.0, delta * 12)
	user.global_position.z = move_toward(user.global_position.z, 0.0, delta * 12)


func Launch():
	var rock = preload("uid://b5vchwrij1m70").instantiate()
	rock.damage = damage
	rock.user = user
	user.attack_container.add_child(rock)
	rock.global_position = user.global_position
	rock.onload()
