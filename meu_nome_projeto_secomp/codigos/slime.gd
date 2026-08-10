extends CharacterBody2D


@export var velocidade_padrao := 50.0
@export var vida := 20.0

var esta_morto := false
var esta_atacando := false
var esta_invuneravel := false
var alvo = null
var direcao := Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not esta_morto:
		#Busca o proximo ponto do caminho até o alvo e aponta a direcao para lá.
		direcao = global_position.direction_to($NavigationAgent2D.get_next_path_position())
		
		#Quando for atingido, a velocidade deve ser definida pela repusão, no restante dos casos move em direcao ao alvo.
		if not esta_invuneravel: 
			velocity = direcao * velocidade_padrao
		
		move_and_slide()
	process_animations()
	
func atingir(dano, direcao_da_repusao):
	if not esta_invuneravel:
		vida -= dano
		esta_invuneravel = true
		$Invunerabilidade.start(0.1)
		velocity = direcao_da_repusao * 100 #knockback
		if vida <= 0:
			morrer()
			
func morrer():
	esta_morto = true
	$Hitbox.collision_mask = 0
	
	
func process_animations():
	$AnimationTree.set("parameters/conditions/esta_parado", direcao == Vector2.ZERO)
	$AnimationTree.set("parameters/conditions/esta_andando", direcao != Vector2.ZERO)
	$AnimationTree.set("parameters/conditions/esta_morto", esta_morto)
	$Sprite2D.set_instance_shader_parameter("esta_invuneravel", esta_invuneravel)

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "morrer":
		queue_free()

func _on_detection_area_body_entered(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		alvo = corpo
		$NavigationAgent2D.target_position = alvo.global_position

func _on_detection_area_body_exited(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		alvo = null


func _on_hitbox_body_entered(corpo: Node2D) -> void:
	if corpo != self and corpo.has_method("atingir") and corpo.is_in_group("jogador"):
		var direcao_de_repulsao = global_position.direction_to(corpo.global_position)
		corpo.atingir(5, direcao_de_repulsao)


func _on_invunerabilidade_timeout() -> void:
	esta_invuneravel = false


func _on_atualizar_caminho_timeout() -> void:
		#Se tiver um alvo para atacar, traça a rota para a posicao do alvo, senao fica no lugar 
		if alvo:
			$NavigationAgent2D.target_position = alvo.global_position
		else:
			$NavigationAgent2D.target_position = self.global_position
			
