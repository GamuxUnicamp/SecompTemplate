extends CharacterBody2D

@export var speed := 100.0
@export var gravity := 500.0
@export var jump := 170.0

@export var projectile:PackedScene
@export var spawn_point := Vector2(25, 70)
# Private
var double_jump = true

func _physics_process(delta):
	#Adiciona gravidade
	velocity.y += gravity * delta
	applyControls() #
	move_and_slide() #Aplica a movimentacao ao player
	applyAnimation() #Aplica a animacao

func applyControls():
	#Define a direcao em que o personagem ira se mover
	velocity.x = Input.get_axis("esquerda", "direita") * speed
	
	if is_on_floor(): #Se estiver no chao, pula e habilita o double_jump
		double_jump = true
			
	if Input.is_action_just_pressed("pular"):
		#Controla o pulo
		if is_on_floor():
			velocity.y = -jump
		elif double_jump: #Se estiver no ar e nao tiver usado o double_jump ainda, da um segundo pulo
			double_jump = false
			velocity.y = -jump
	
	#Dispara ao apertar o botao de atirar
	if Input.is_action_just_pressed("atirar"):
		shoot()
	
func shoot():
	var _projectile = projectile.instantiate()
	get_tree().get_root().add_child(_projectile)
	
	if !$Sprite.flip_h:
		_projectile.direction = 1
		_projectile.position = position + Vector2( 12, 2) # Projectile spawn position
	else:
		_projectile.position = position + Vector2(-12, 2) # Projectile spawn position
		
# Set animations
func applyAnimation():
	
	if velocity.x < 0:
		$Sprite.flip_h = true #Inverte o personagem quando anda para a esquerda
	else:
		$Sprite.flip_h = false
		
	if is_on_floor():
		if abs(velocity.x) > 60:
			$Sprite.play("walk")
		else:
			$Sprite.play("idle")
	else:
		$Sprite.play("jump")

func respawn():
	global_position = spawn_point
