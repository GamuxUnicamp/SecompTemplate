#player movement script
extends CharacterBody2D

@export var velocidade_padrao = 75.0
var direcao  = Vector2.ZERO

func _physics_process(delta: float) -> void:
	direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
	velocity = direcao * velocidade_padrao
	move_and_slide()
