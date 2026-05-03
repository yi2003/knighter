extends CharacterBody2D

@export var speed: float = 80.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _direction: int = -1
var _dying: bool = false
var _death_y: float = 0.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _stomp_area: Area2D = $StompArea
@onready var _death_sfx: AudioStreamPlayer2D = $DeathSFX


func _physics_process(delta: float) -> void:
	if _dying:
		velocity.y += gravity * delta
		global_position.y += velocity.y * delta
		_check_off_screen()
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_wall():
		_direction *= -1

	velocity.x = _direction * speed
	_sprite.flip_h = _direction > 0

	move_and_slide()


func _on_stomp_area_body_entered(body: Node2D) -> void:
	if body.name != "Player" or _dying:
		return
	var player := body as CharacterBody2D
	if player and player.velocity.y <= 0:
		return
	_die()


func _die() -> void:
	_dying = true
	_death_y = global_position.y
	collision_layer = 0
	_stomp_area.set_deferred("monitoring", false)
	_sprite.modulate = Color(1, 1, 1, 0.6)
	_death_sfx.play()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.name != "Player" or _dying:
		return
	# if player is above the slime, stomp handles it instead
	if body.global_position.y + 20 < global_position.y:
		return
	body.die()


func _check_off_screen() -> void:
	if global_position.y - _death_y > 500:
		queue_free()
