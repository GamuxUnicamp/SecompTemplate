extends CanvasLayer

func _on_player_player_morreu() -> void:
	$AnimationPlayer.play("tela_de_morte")


func _on_player_atualizar_max_vida(nova_vida_maxima: Variant) -> void:
	$BarraDeVida.max_value = nova_vida_maxima


func _on_player_atualizar_vida(vida_atual: Variant) -> void:
	$BarraDeVida.value = vida_atual
