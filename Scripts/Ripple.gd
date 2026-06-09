@tool
extends Area3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D


func _physics_process(delta: float) -> void:
	collision_shape_3d.shape.set_faces(mesh_instance_3d.mesh.get_faces())
	mesh_instance_3d.mesh.outer_radius = 10.0

func Increase_Radius():
	pass
