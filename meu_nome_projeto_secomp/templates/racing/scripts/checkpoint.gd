extends Area2D
signal win(player_name : String)

@export_range(1, 4, 1) var checkpoint_num := 0
@export var win_condition := 9
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("car"):
		if body.current_checkpoint % 4 == checkpoint_num - 1:
			body.current_checkpoint += 1
		if body.current_checkpoint == win_condition:
			win.emit(body.name)
