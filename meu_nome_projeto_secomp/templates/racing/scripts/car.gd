extends CharacterBody2D

@export_enum("p1", "p2") var player: String = "p1"
@export_range(0, 4, 1, "Car color") var car_color := 0
# Engine parameters
@export var max_speed: float = 600.0
@export var acceleration: float = 300.0
@export var friction: float = 200.0
@export var braking: float = 500.0
@export var steering_speed: float = 4.0  # Turn rate in radians per second
@export var enabled := false
@export var current_checkpoint := 0
var current_speed: float = 0.0

func _ready() -> void:
	$Sprite2D.frame = car_color 

func _physics_process(delta):
	if not enabled:
		return
# 1. Get player input
	var forward_input: float = Input.get_axis("%s_brecar" % player, "%s_acelerar" % player) 
	var turn_input: float = Input.get_axis("%s_virar_esq" % player, "%s_virar_dir" % player) 
	
	# 2. Handle acceleration and braking/friction
	if forward_input > 0:
		# Accelerate forward
		current_speed += acceleration * delta
	elif forward_input < 0:
		# Apply brakes or reverse
		if current_speed > 0:
			current_speed -= braking * delta
		else:
			current_speed -= acceleration * delta # Move backwards
	else:
		# Apply natural friction when no input is given
		current_speed = move_toward(current_speed, 0, friction * delta)
	
	# Clamp speed to the maximum allowed limit
	current_speed = clamp(current_speed, -max_speed / 2.0, max_speed)
	
	# 3. Handle steering (Only allow turning if the car is moving)
	if abs(current_speed) > 10.0:
		# Invert steering when reversing so it handles like a real car
		var direction_modifier = -1.0 if current_speed < 0 else 1.0
		rotation += turn_input * steering_speed * direction_modifier * delta
	
	# 4. Apply velocity based on the current rotation and speed
	velocity = Vector2.RIGHT.rotated(rotation) * current_speed
	
	# 5. Move the car and handle collisions
	move_and_slide()
