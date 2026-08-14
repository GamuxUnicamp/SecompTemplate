#slime movement script
extends CharacterBody2D

@export var velocidade_padrao = 50.0

var alvo = null
var direcao = Vector2.ZERO

func _physics_process(delta: float) -> void:
	#Busca o proximo ponto do caminho até o alvo e aponta a direcao para lá.
	direcao = global_position.direction_to($NavigationAgent2D.get_next_path_position())
	velocity = direcao * velocidade_padrao
	move_and_slide()
	

func _on_detection_area_body_entered(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		alvo = corpo
		$NavigationAgent2D.target_position = alvo.global_position

func _on_detection_area_body_exited(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		alvo = null

func _on_atualizar_caminho_timeout() -> void:
		#Se tiver um alvo para atacar, traça a rota para a posicao do alvo, senao fica no lugar 
		if alvo:
			$NavigationAgent2D.target_position = alvo.global_position
		else:
			$NavigationAgent2D.target_position = self.global_position
			
