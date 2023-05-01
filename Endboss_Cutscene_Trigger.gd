extends Area2D

func _on_body_entered(body):
	if(body.name == "PizzaBoy"):
		get_owner().get_node("AnimationPlayer").play("endboss_cutscene")
		self.queue_free()
