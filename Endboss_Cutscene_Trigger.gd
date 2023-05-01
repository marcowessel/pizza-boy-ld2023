extends Area2D

func _on_body_entered(body):
	if(body.name == "PizzaBoy"):
		get_owner().get_node("AnimationPlayer").play("endboss_cutscene")
		get_owner().get_node("Combat_Music").stop()
		self.queue_free()


