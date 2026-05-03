extends AnimatableBody2D

@export var speed: float = 100.0
@export var distance: float = 200.0

var _start_pos: Vector2
var _direction: int = 1


func _ready() -> void:
	_start_pos = global_position


func _physics_process(delta: float) -> void:
	var offset: float = global_position.x - _start_pos.x
	if abs(offset) >= distance:
		_direction *= -1

	global_position.x += _direction * speed * delta
