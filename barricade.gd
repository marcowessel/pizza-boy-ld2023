extends Node2D

var collision
const GROUP_NAME = "barricade"


func _ready():
	collision = $CollisionShape2D
	self.add_to_group(GROUP_NAME)


func deactivate():
	call_deferred("_deactivate")
	
func _deactivate():
	collision.disabled = true
	self.visible = false


func activate():
	call_deferred("_activate")


func _activate():
	collision.disabled = false
	self.visible = true
