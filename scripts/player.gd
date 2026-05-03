extends CharacterBody2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var dead: bool = false

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if dead:
		velocity.y += gravity * delta
		global_position.y += velocity.y * delta
		_check_off_screen()
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var direction: float = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
		_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	_update_animation(direction)
	move_and_slide()


func die() -> void:
	if dead:
		return
	dead = true
	velocity.x = 0
	velocity.y = -200
	collision_layer = 0
	_sprite.modulate = Color(1, 1, 1, 0.6)


func _check_off_screen() -> void:
	if global_position.y > 2000:
		get_tree().reload_current_scene()


func _update_animation(direction: float) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			_sprite.play(&"jump")
		else:
			_sprite.play(&"fall")
	elif direction:
		_sprite.play(&"run")
	else:
		_sprite.play(&"idle")
