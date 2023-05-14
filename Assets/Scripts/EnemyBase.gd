class_name EnemyBase

extends CharacterBody2D

@export var health:int


func _init():
	add_to_group("destructable")


func take_damage(damage):
	if (health - damage <= 0):
		health = 0
		dies()
	else:
		health -= damage


func dies():
	self.queue_free()
