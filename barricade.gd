extends StaticBody2D

var collision
const GROUP_NAME = "barricade"


func _ready():
	collision = $CollisionShape2D
	self.add_to_group(GROUP_NAME)


func deactivate():
	collision.disabled = true
	self.visible = false

	
func activate():	
	collision.disabled = false
	self.visible = true
