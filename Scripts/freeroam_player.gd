extends Player

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	Normal_Camera(event)

func _physics_process(delta: float) -> void:
	Normal_Movement(delta)
