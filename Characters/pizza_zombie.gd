extends CharacterBody2D

var pizza_piece_scene = preload("res://pizza_piece_item.tscn") 
	
@export var health:int = 5
@export var walking_speed = 100

var player
var has_pizza_piece = false
var anim_player
var is_dead = false


func _ready():
	$PizzaPieceItem/CollisionShapeDamage.queue_free()
	player = get_node("%PizzaBoy")
	self.add_to_group("enemy")
	anim_player = $AnimationPlayer


func _process(delta):
	if !has_pizza_piece and !is_dead:
		run_towards_player(delta)
	elif has_pizza_piece and !is_dead:
		run_away()


func run_towards_player(delta):
	#(366.6868, 795.4508)(446.6774, 776.8185)
	anim_player.play("walk")
	var target_position = player.position
	print(target_position, position)
	var new_position = position.move_toward(
		target_position, 
		walking_speed * delta
	)
	position = new_position
	flip_to_player(target_position)

func flip_to_player(target_position):
	if target_position.x - position.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

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
	is_dead = true
	if has_pizza_piece: drop_pizza_piece()
	$Death.rplay()
	anim_player.play("death")
	$ZombieFeet.queue_free()
	$DamageArea/CollisionShape2D.queue_free()
	#$Sprite2D.hide()
	$Dust.emitting = true
	await get_tree().create_timer(2).timeout
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
			$Haha.rplay()
