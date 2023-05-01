extends Area2D

func _ready():
	self.add_to_group("pizza_piece")

func _on_body_entered(body):
	if body.name == "PizzaBoy" and body.pizza_pieces < body.max_pizza_pieces:
		body.pickup_piece()
		self.queue_free()
