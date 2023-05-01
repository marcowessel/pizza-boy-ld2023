extends Area2D

var barricades


func _ready():
	barricades = get_tree().get_nodes_in_group("barricade")
	deactivate_barricades()

func _on_body_entered(body):
	if(body.name == "PizzaBoy"):
		disable_camera_movement()
		activate_barricades()
		$CollisionShape2D.disabled = true
		#execute battle arena script
		
func disable_camera_movement():
	var camera = get_node("%MainCamera")
	camera.set_follow_active(false)
	
func activate_barricades():
	for barricade in barricades:
		barricade.activate()
	
func deactivate_barricades():
	for barricade in barricades:
		barricade.deactivate()
