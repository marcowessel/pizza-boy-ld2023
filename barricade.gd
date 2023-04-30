extends StaticBody2D

var collision


func _ready():
	collision = $CollisionShape2D


func deactivate_barricade():
	collision.disabled = true
	self.visible = false

	
func activate_barricade():	
	collision.disabled = false
	self.visible = true
