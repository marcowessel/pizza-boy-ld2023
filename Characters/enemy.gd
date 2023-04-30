extends CharacterBody2D

@export var health:int = 10;


func _ready():
	self.add_to_group("enemy")


func take_damage(damage):
	if (health - damage <= 0):
		health = 0
		dies()
	else:
		print("Leben " + str(health))
		health -= damage
		print("damage = " + str(damage))
		print("Neues Leben " + str(health))


func dies():
	self.queue_free() 
