extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_viewport().get_visible_rect().size.y == 1440:
		scale = Vector2(8,8)
		print(1440)
	if get_viewport().get_visible_rect().size.y == 1080:
		scale = Vector2(6,6)
		print(1080)
