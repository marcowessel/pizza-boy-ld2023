extends Node2D

var collision
const GROUP_NAME = "barricade"


func _ready():
	collision = $CollisionShape2D
	self.add_to_group(GROUP_NAME)


func deactivate():
	print(str(collision.disabled) + "barricade")
	collision.disabled = true
	self.visible = false

	
func activate():	
	collision.disabled = false
	self.visible = true
	#call_deferred("_activate")


#func _activate():
	#$StaticBody2D.set_shape_disabled(0, false)
