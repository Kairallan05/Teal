extends Area3D

var damage
var user
var target : Vector3
var origin : Vector3
var midpoint : Vector3
var t : float


func onload() -> void:
	origin = global_position
	origin.y += 1
	t = 0.0
	var rng = RandomNumberGenerator.new()
	var x = rng.randi_range(-10.0, 10.0)
	var z = rng.randi_range(-10.0, 10.0)
	target = Vector3(x,0.8,z)
	midpoint = (origin + target)/2
	midpoint.y += 5


func _physics_process(delta: float) -> void:
	var start = origin.lerp(midpoint, t)
	var end = midpoint.lerp(target, t)
	var curve = start.lerp(end, t)
	t += 0.02
	global_position = curve
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
			Player_Statistics.health -= damage
			body.velocity += origin.direction_to(body.global_position).normalized() * 10
			body.velocity.y += 5
	if body.is_in_group("floor"):
		var Ripple = preload("uid://ccl0u5ljqusv2").instantiate()
		Ripple.damage = damage
		Ripple.size = 5.0
		Ripple.speed = 10.0
		user.attack_container.add_child(Ripple)
		Ripple.global_position = global_position
		queue_free()
