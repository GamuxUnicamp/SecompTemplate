extends CharacterBody2D

signal player_morreu

@export var velocidade_padrao := 75.0
@export var vida := 30
@export var esta_morto := false
@export var esta_atacando := false

var direcao := Vector2.ZERO
var ultima_dir := Vector2.ZERO
var esta_invuneravel := false

func _physics_process(delta: float) -> void:
	if not esta_morto:
		direcao = Vector2.ZERO
		direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
		if Input.is_action_just_pressed("atacar") and not esta_atacando:
			esta_atacando = true
			$Cooldown.start(0.8)
		if direcao != Vector2.ZERO:
			ultima_dir = direcao
		if not esta_invuneravel:
			velocity = direcao * velocidade_padrao
		move_and_slide()
	process_animations()

func atingir(dano, direcao_da_repusao):
	if not esta_invuneravel:
		vida -= dano
		esta_invuneravel = true
		$Invuneravel.start(0.1)
		velocity = direcao_da_repusao * 100
		if vida <= 0:
			morrer()

func morrer():
	collision_layer = 0
	esta_morto = true
	player_morreu.emit()
	
func process_animations():
	$AnimationTree.set("parameters/parado/blend_position", ultima_dir)
	$AnimationTree.set("parameters/andando/blend_position", ultima_dir)
	$AnimationTree.set("parameters/atacando/blend_position", ultima_dir)
	$AnimationTree.set("parameters/conditions/esta_parado", direcao == Vector2.ZERO)
	$AnimationTree.set("parameters/conditions/esta_andando", direcao != Vector2.ZERO)
	$AnimationTree.set("parameters/conditions/esta_morto", esta_morto)
	$AnimationTree.set("parameters/conditions/esta_atacando", esta_atacando)
	$Sprite2D.set_instance_shader_parameter("esta_invuneravel", esta_invuneravel)

func _on_cooldown_timeout() -> void:
	esta_atacando = false


func _on_hitbox_body_entered(corpo: Node2D) -> void:
	if corpo != self and corpo.has_method("atingir"):
		var direcao_da_repulsao = global_position.direction_to(corpo.global_position)
		corpo.atingir(5, direcao_da_repulsao)

func _on_invuneravel_timeout() -> void:
	esta_invuneravel = false
