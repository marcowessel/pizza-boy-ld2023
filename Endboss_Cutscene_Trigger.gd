extends Area2D

func _on_body_entered(body):
	if(body.name == "PizzaBoy"):
		get_owner().get_node("AnimationPlayer").play("endboss_cutscene")
		get_owner().get_node("Combat_Music").stop()
		self.queue_free()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "endboss_cutscene":
		get_owner().get_node("Boss_Song").play()
