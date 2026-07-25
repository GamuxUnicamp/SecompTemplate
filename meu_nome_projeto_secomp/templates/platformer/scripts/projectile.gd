extends Area2D

var direction = 0
var speed = 200

func _process(delta) -> void:
	if direction == 0:
		position.x -= speed * delta
		$Sprite.flip_h = true
	else:
		position.x += speed * delta
		$Sprite.flip_h = false


func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("hit"):
		body.hit()
	queue_free()
