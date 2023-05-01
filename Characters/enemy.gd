extends CharacterBody2D

@export var health:int = 10;


func _ready():
	self.add_to_group("enemy")


func take_damage(damage):
	if (health - damage <= 0):
		health = 0
		$Sprite2D.hide()
		$Dust.emitting = true
		$CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = true
		await get_tree().create_timer(1.0).timeout
		dies()
	else:
		#print("Leben " + str(health))
		health -= damage
		#print("damage = " + str(damage))
		#print("Neues Leben " + str(health))


func dies():
	self.queue_free() 
