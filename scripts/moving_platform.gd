extends AnimatableBody2D

@export var speed: float = 100.0

var _direction: int = 1

@onready var _ray_left: RayCast2D = $RayLeft
@onready var _ray_right: RayCast2D = $RayRight


func _physics_process(delta: float) -> void:
	global_position.x += _direction * speed * delta

	if _direction > 0 and _ray_right.is_colliding():
		_direction = -1
	elif _direction < 0 and _ray_left.is_colliding():
		_direction = 1
