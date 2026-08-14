#player combat script
extends CharacterBody2D

@export var velocidade_padrao = 75.0
@export var vida = 20
@export var max_vida = 20
@export var dano_ataque = 5
@export var esta_morto = false
@export var esta_atacando = false
@export var esta_invulneravel = false

var direcao = Vector2.ZERO
var ultima_dir = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if not esta_morto:
		direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
		if Input.is_action_just_pressed("atacar") and not esta_atacando:
			esta_atacando = true
			$Cooldown.start(0.8)
		if direcao != Vector2.ZERO:
			ultima_dir = direcao
		if not esta_invulneravel:
			velocity = direcao * velocidade_padrao
		move_and_slide()
	processar_animacoes()

func receber_ataque(dano, direcao_da_repusao):
	if not esta_invulneravel:
		vida -= dano
		esta_invulneravel = true
		$Invulneravel.start(0.1)
		velocity = direcao_da_repusao * 100
		if vida <= 0:
			morrer()

func morrer():
	collision_layer = 0
	esta_morto = true
	
func processar_animacoes():
	$AnimationTree.set("parameters/parado/blend_position", ultima_dir)
	$AnimationTree.set("parameters/andando/blend_position", ultima_dir)
	$AnimationTree.set("parameters/atacando/blend_position", ultima_dir)
	$AnimationTree.set("parameters/conditions/esta_parado", direcao == Vector2.ZERO)
	$AnimationTree.set("parameters/conditions/esta_andando", direcao != Vector2.ZERO)
	$AnimationTree.set("parameters/conditions/esta_morto", esta_morto)
	$AnimationTree.set("parameters/conditions/esta_atacando", esta_atacando)
	$Sprite2D.set_instance_shader_parameter("esta_invulneravel", esta_invulneravel)

func _on_cooldown_timeout() -> void:
	esta_atacando = false


func atingir(corpo: Node2D) -> void:
	if corpo != self and corpo.has_method("receber_ataque"):
		var direcao_da_repulsao = global_position.direction_to(corpo.global_position)
		corpo.receber_ataque(dano_ataque, direcao_da_repulsao)

func _on_invulneravel_timeout() -> void:
	esta_invulneravel = false
