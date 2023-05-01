extends Area2D

func _on_area_entered(area):
	if area.is_in_group("pizza_piece"):
		print("spotted pizza")
		get_parent().found_pizza_piece = true
		get_parent().found_pizza_piece_position = area.position


func _on_area_exited(area):
	if area.is_in_group("pizza_piece"):
		print("pizza gone")
		get_parent().found_pizza_piece = false
		get_parent().found_pizza_piece_position = Vector2.ZERO
