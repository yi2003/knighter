extends Area2D

const COIN_SCENE := preload("res://scenes/coin.tscn")

@export var hits_required: int = 3

var _hit_count: int = 0
var _can_hit: bool = true

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _hit_sfx: AudioStreamPlayer2D = $HitSFX
@onready var _break_sfx: AudioStreamPlayer2D = $BreakSFX


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" or not _can_hit:
		return

	if body.global_position.y < global_position.y:
		return

	var player := body as CharacterBody2D
	if player and player.velocity.y >= 0:
		return

	_can_hit = false
	_hit_count += 1
	_flash()

	if _hit_count >= hits_required:
		_break_sfx.play()
		_spawn_coin()
		await get_tree().create_timer(0.3).timeout
		queue_free()
	else:
		_hit_sfx.play()
		await get_tree().create_timer(0.5).timeout
		_can_hit = true


func _flash() -> void:
	_sprite.modulate = Color(2, 2, 2, 1)
	var tween := create_tween()
	tween.tween_property(_sprite, "modulate", Color(1, 1, 1, 1), 0.15)


func _spawn_coin() -> void:
	var coin := COIN_SCENE.instantiate()
	get_parent().add_child(coin)
	coin.global_position = global_position
