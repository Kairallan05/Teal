@tool
class_name Grassify
extends Node3D


@onready var multi_mesh_instance: MultiMeshInstance3D = $MultiMeshInstance3D
@onready var ray_cast: RayCast3D = $RayCast3D
@onready var static_body: StaticBody3D = $StaticBody3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

var regenerate: bool = true

## The texture of the instances.
@export var texture: Texture = preload("res://Grassify/default_texture.png"):
	set(value):
		texture = value
		_queue_regenerate()

## The mesh to spawn the instances on.
## When faces overlap vertically, only the top-most will used.
@export var mesh: Mesh = preload("res://Grassify/default_mesh.res"):
	set(value):
		mesh = value
		_queue_regenerate()

@export_category("Placement")

## Map used for grass placement along with threshold.
## Consider using a NoiseTexture2D.
@export var map: Texture2D = preload("res://Grassify/default_noise.tres"):
	set(value):
		map = value
		_queue_regenerate()

## Points on the map above this threshold will be valid instance spawn locations.
@export_range(0, 1, 0.01) var threshold: float = 0.5:
	set(value):
		threshold = value
		_queue_regenerate()

## Instances per coordinate unit.
@export_range(0, 5, 0.01) var density: float = 3.0:
	set(value):
		density = value
		_queue_regenerate()

@export var randomize_position: bool = true:
	set(value):
		randomize_position = value
		_queue_regenerate()

@export var randomize_rotation: bool = true:
	set(value):
		randomize_rotation = value
		_queue_regenerate()

@export var randomize_scale: bool = true:
	set(value):
		randomize_scale = value
		_queue_regenerate()

@export_tool_button("Regenerate", "Reload") var regenerate_action = _queue_regenerate

var temp_buffer := PackedFloat32Array()
var noise_scale: float = 1.0
var size := Vector2.ZERO
var mesh_offset := Vector3.ZERO


func _ready() -> void:
	if map is NoiseTexture2D:
		await map.changed


func _process(_delta: float) -> void:
	if regenerate and ready:
		regenerate = false
		_generate()
		
		if not Engine.is_editor_hint():
			ray_cast.queue_free()
			static_body.queue_free()


func _notification(what: int) -> void:
	# Stop the multimesh buffer from being stored in the scene.
	if what == NOTIFICATION_EDITOR_PRE_SAVE:
		temp_buffer = multi_mesh_instance.multimesh.buffer
		multi_mesh_instance.multimesh.instance_count = 0
	
	if what == NOTIFICATION_EDITOR_POST_SAVE:
		multi_mesh_instance.multimesh.instance_count = int(len(temp_buffer) / 12.0)
		multi_mesh_instance.multimesh.buffer = temp_buffer
		temp_buffer = PackedFloat32Array()


func _queue_regenerate() -> void:
	regenerate = true


func _generate() -> void:
	_generate_mesh_info()
	_generate_noise_scale()
	_generate_instance_mesh()
	_generate_instances()


func _generate_mesh_info() -> void:
	multi_mesh_instance.multimesh.custom_aabb = mesh.get_aabb()
	size = Vector2(mesh.get_aabb().size.x, mesh.get_aabb().size.z)
	mesh_offset = mesh.get_aabb().position
	collision_shape.shape.set_faces(mesh.get_faces())


func _generate_noise_scale() -> void:
	var map_size: Vector2 = map.get_size()
	noise_scale = max(map_size.x / size.x, map_size.y / size.y)


func _generate_instance_mesh() -> void:
	var surface_array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	surface_array[Mesh.ARRAY_VERTEX] = PackedVector3Array()
	for y in [0, 1]:
		for x in [-0.5, 0.5]:
			surface_array[Mesh.ARRAY_VERTEX].push_back(Vector3(x, y, 0))
		for z in [-0.5, 0.5]:
			surface_array[Mesh.ARRAY_VERTEX].push_back(Vector3(0, y, z))
		
	surface_array[Mesh.ARRAY_TEX_UV] = PackedVector2Array()
	for y in [1, 0]:
		for i in 2:
			for x in [0, 1]:
				surface_array[Mesh.ARRAY_TEX_UV].push_back(Vector2(x, y))
	
	surface_array[Mesh.ARRAY_NORMAL] = PackedVector3Array()
	for i in 8:
		surface_array[Mesh.ARRAY_NORMAL].push_back(Vector3.UP)
	
	surface_array[Mesh.ARRAY_INDEX] = PackedInt32Array([
		0, 1, 4, 4, 1, 5,
		2, 3, 6, 6, 3, 7,
	])
	
	var instance_mesh := ArrayMesh.new()
	instance_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	instance_mesh.surface_set_name(0, "Cross Billboard")
	
	var instance_material := StandardMaterial3D.new()
	instance_material.albedo_texture = texture
	instance_material.cull_mode = BaseMaterial3D.CULL_DISABLED
	instance_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	instance_material.texture_repeat = false
	instance_material.backlight_enabled = true
	instance_material.backlight = Color.WHITE
	instance_mesh.surface_set_material(0, instance_material)
	
	multi_mesh_instance.multimesh.mesh = instance_mesh


func _generate_instances() -> void:
	var image: Image = map.get_image()
	var transforms: Array[Transform3D] = []
	
	var x: float = 0.0
	while x < size.x:
		var y: float = 0.0
		while y < size.y:
			var point = image.get_pixel(int(x * noise_scale), int(y * noise_scale)).get_luminance()
			if point >= threshold:
				var xform = _generate_instance_transform(Vector3(x + mesh_offset.x, mesh_offset.y, y + mesh_offset.z))
				if xform != null:
					transforms.push_back(xform)
			y += 1 / density
		x += 1 / density
	
	multi_mesh_instance.multimesh.instance_count = len(transforms)
	for i in len(transforms):
		multi_mesh_instance.multimesh.set_instance_transform(i, transforms[i])


## Takes a, b, and c values and produces a number between 0.0 and 1.0
func _fixed_rand(a: float, b: float, c: float) -> float:
	return sin((a + 3) ** 3 + (b + 2) ** 2 + (c + 1)) * 0.5 + 0.5


func _generate_instance_transform(pos: Vector3) -> Variant:
	var xform := Transform3D()
	
	if randomize_rotation:
		var y_rotation = _fixed_rand(pos.x, pos.z, 1) * 2 * PI
		xform = xform.rotated(Vector3.UP, y_rotation)
	
	if randomize_scale:
		var scale_factor: float = _fixed_rand(pos.z, pos.x, 2) * 0.5 + 0.5
		xform = xform.scaled(Vector3(scale_factor, scale_factor, scale_factor))
		
	if randomize_position:
		pos.x += (_fixed_rand(pos.x, pos.z, 4) - 0.5) / density
		pos.z += (_fixed_rand(pos.z, pos.x, 8) - 0.5) / density
	
	var height: Variant = _get_mesh_height_at_point(pos)
	if height == null:
		return null
	
	pos.y = height
	
	return xform.translated(pos)


func _get_mesh_height_at_point(pos: Vector3) -> Variant:
	ray_cast.position = pos + Vector3(0, 10, 0)
	ray_cast.force_raycast_update()
	
	if not ray_cast.is_colliding():
		return null
	
	return ray_cast.get_collision_point().y
