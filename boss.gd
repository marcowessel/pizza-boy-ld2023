extends CharacterBody2D

@export var health:int = 1
@export var walking_speed = 100

var is_activated = false
var player


func _ready():
	self.add_to_group("destructable")


func take_damage(damage):
	if (health - damage <= 0):
		health = 0
		dies()
	else:
		health -= damage


func dies():
	print("boss dead")
	self.queue_free() 


func activate():
	print("boss activated")
	player = get_node("%PizzaBoy")
	is_activated = true


func _process(delta):
	if is_activated:
		run_towards_player(delta)


func run_towards_player(delta):
	var target_position = player.position
	var new_position = position.move_toward(
		target_position, 
		walking_speed * delta
	)
	position = new_position
