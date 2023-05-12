extends Area2D


func _on_area_entered(area):
	if area.is_in_group("pizza_piece"):
		spotted_pizza(area)


func spotted_pizza(pizza_piece):
	get_parent().found_pizza_piece = true
	get_parent().found_pizza_piece_position = pizza_piece.position


func _on_area_exited(area):
	if area.is_in_group("pizza_piece"):
		spotted_pizza_gone()


func spotted_pizza_gone():
	get_parent().found_pizza_piece = false
	get_parent().found_pizza_piece_position = Vector2.ZERO
