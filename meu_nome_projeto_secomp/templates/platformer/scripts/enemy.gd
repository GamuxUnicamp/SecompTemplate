extends CharacterBody2D

@onready var sprite = $Sprite

@export var speed = 50
@export var orientation = "vertical"
@export var direction = -1

func _physics_process(delta):
	if orientation == "vertical":
		if is_on_ceiling() or is_on_floor():
			direction = -direction #Inverte a direcao ao bater no teto ou no chao
		velocity.y = direction * speed
	elif orientation == "horizontal":
		if is_on_wall():
			direction = -direction #Inverte a direcao ao bater na parede
		velocity.x = direction * speed
		
		if direction == -1:
			sprite.flip_h = true #inverte o sprite caso esteja indo pra esquerda
		else:
			sprite.flip_h = false
	
	move_and_slide()
	
func hit():
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.respawn()
