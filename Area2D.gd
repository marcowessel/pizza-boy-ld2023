extends Area2D

func _on_body_entered(body:CharacterBody2D):
	if(body.name == "PizzaBoy"):
		disable_camera_movement()
		activate_barricades()
		#execute battle arena script
		
func disable_camera_movement():
	var camera = get_node("%MainCamera")
	camera.set_follow_active(false)
	
func activate_barricades():
	pass
	
func deactivate_barricades():
	pass
