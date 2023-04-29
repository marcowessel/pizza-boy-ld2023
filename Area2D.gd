extends Area2D

# TODO
# - [] check for collision

func _on_body_entered(body:CharacterBody2D):
	if(body.name == "PizzaBoy"):
		#disable camera movement
		var camera = get_node("%MainCamera")
		camera.set_follow_active(false)
		
		#execute battle arena script
