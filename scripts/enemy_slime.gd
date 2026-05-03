extends CharacterBody2D

@export var speed: float = 80.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction: int = -1

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall():
		_direction *= -1

	velocity.x = _direction * speed
	_sprite.flip_h = _direction > 0

	move_and_slide()


func _on_stomp_area_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	var player := body as CharacterBody2D
	if player and player.velocity.y <= 0:
		return
	queue_free()


