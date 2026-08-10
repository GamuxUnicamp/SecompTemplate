extends Node2D

func _on_start_pressed() -> void:
	%Start.hide()
	%Counter.show()
	%Timer.start(1)

func _on_timer_timeout() -> void:
	var valor_counter = int(%Counter.text) - 1 #Converte o texto do contador em numero e subtrai 1
	if valor_counter == 0:
		$Car.enabled = true
		$Car2.enabled = true
		%Counter.hide()
	%Counter.text = str(valor_counter) #Converte de volta pra texto
	


func _on_checkpoint_1_win(player_name: String) -> void:
	%Result.show()
	var result_text = "Player 1 won!" if player_name == "Car" else "Player 2 won!"
	%Result.text = "[wave amp=50.0 freq=5.0 connected=1]%s[/wave]" % result_text
	$Car.enabled = false
	$Car2.enabled = false
