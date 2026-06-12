extends Area3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
var damage
var size
var speed

func _ready() -> void:
	mesh_instance_3d.mesh = mesh_instance_3d.mesh.duplicate()
	collision_shape_3d.shape = collision_shape_3d.shape.duplicate()


func _physics_process(delta: float) -> void:
	collision_shape_3d.shape.set_faces(mesh_instance_3d.mesh.get_faces())
	Increase_Radius(delta)

func Increase_Radius(delta):
	mesh_instance_3d.mesh.outer_radius = move_toward(mesh_instance_3d.mesh.outer_radius,size,delta * speed)
	mesh_instance_3d.mesh.inner_radius = mesh_instance_3d.mesh.outer_radius - 0.5
	if mesh_instance_3d.mesh.outer_radius == size:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
			Player_Statistics.health -= damage
			body.velocity.y += 10
