extends CharacterBody2D

var pizza_piece_scene = preload("res://pizza_piece_item.tscn") 
	
@export var health:int = 5
@export var walking_speed = 100

var player
var has_pizza_piece = false


func _ready():
	$PizzaPieceItem/CollisionShapeDamage.queue_free()
	player = get_node("%PizzaBoy")
	self.add_to_group("enemy")


func _process(delta):
	if !has_pizza_piece:
		run_towards_player(delta)
	else:
		run_away()


func run_towards_player(delta):
	var target_position = player.position
	var new_position = position.move_toward(
		target_position, 
		walking_speed * delta
	)
	position = new_position

func run_away():
	#TODO implement
	pass


func take_damage(damage):
	if (health - damage <= 0):
		health = 0
		dies()
	else:
		#print("Leben " + str(health))
		health -= damage
		#print("damage = " + str(damage))
		#print("Neues Leben " + str(health))


func dies():
	if has_pizza_piece: drop_pizza_piece()
	$ZombieFeet.queue_free()
	$DamageArea/CollisionShape2D.queue_free()
	$Sprite2D.hide()
	self.queue_free() 


func drop_pizza_piece():
	var pizza_piece_item = pizza_piece_scene.instantiate()
	pizza_piece_item.position = position
	pizza_piece_item.set_rotation_degrees(randi_range(0, 360))
	get_tree().get_root().add_child(pizza_piece_item)


func _on_damage_area_area_entered(area):
	var body = area.get_parent()
	if !body.is_in_group("player"): return
	if area.name == "HitDetection":
		if body.pizza_pieces != 0:
			$PizzaPieceItem.visible = true
			has_pizza_piece = true

