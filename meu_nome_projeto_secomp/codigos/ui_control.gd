extends CanvasLayer

func _ready() -> void:
	$BarraDeVida.max_value = $"../Player".vida
	
func _process(delta: float) -> void:
	$BarraDeVida.value = $"../Player".vida

func _on_player_player_morreu() -> void:
	$AnimationPlayer.play("tela_de_morte")
