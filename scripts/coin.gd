extends Area2D

var _collected: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player" or _collected:
		return
	_collected = true
	monitoring = false
	$AnimatedSprite2D.visible = false
	$CoinSFX.play()
	await get_tree().create_timer(0.3).timeout
	queue_free()
