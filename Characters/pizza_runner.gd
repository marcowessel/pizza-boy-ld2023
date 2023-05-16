extends CharacterBody2D

var pizza_piece_scene = preload("res://pizza_piece_item.tscn") 
	
@export var health:int = 4
@export var walking_speed = 300
@export var score_count = 20

var player = null
var has_pizza_piece = false
var spawn_position:Vector2 = Vector2.ZERO
var anim_player
var is_dead = false
var found_pizza_piece = false
var found_pizza_piece_position = Vector2.ZERO
var animation_has_stopped = false

func _ready():
	$PizzaPieceItem/CollisionShapeDamage.queue_free()
	self.add_to_group("enemy")
	player = get_parent().get_node("PizzaBoy")
	anim_player = $AnimationPlayer


func _process(delta):
	if found_pizza_piece:
		#TODO audio clip found pizza
		$Exclamation_Mark.show()
	else:
		$Exclamation_Mark.hide()
	
	if !has_pizza_piece and !is_dead and !found_pizza_piece:
		run_towards_player(delta)
	elif has_pizza_piece and !is_dead:
		run_away(delta)
	elif !has_pizza_piece and found_pizza_piece:
		move_to_pizza(delta)
	
	if player.is_dead:
		if !animation_has_stopped:
			anim_player.stop()
			animation_has_stopped = true


func run_towards_player(delta):
	#(366.6868, 795.4508)(446.6774, 776.8185)
	if !player.is_dead:
		anim_player.play("walk")
		var target_position = player.position
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


func run_away(delta):
	if !player.is_dead:
		anim_player.play("walk")
		var target_position = spawn_position
		var new_position = position.move_toward(
			target_position, 
			walking_speed * delta
		)
		position = new_position
		flip_to_target(target_position)


func flip_to_target(target_position):
	if target_position.x - position.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false


func take_damage(damage):
	if (health - damage <= 0):
		health = 0
		dies()
	else:
		$Hurt.rplay()
		health -= damage

func dies():
	var player = get_tree().current_scene.get_node("%PizzaBoy")
	player.kill_count += 1
	Score.combo += 1
	Score.score += score_count * Score.combo
	print("combo =", Score.combo)
	
	$PizzaRadar.queue_free()
	is_dead = true
	if has_pizza_piece: drop_pizza_piece()
	$Death.rplay()
	$Score_Anim.play("score")
	anim_player.play("death")
	$ZombieFeet.queue_free()
	$DamageArea/CollisionShape2D.queue_free()
	hidden()
	$Sprite2D.z_index -= 1
	await get_tree().create_timer(2).timeout
	$Sprite2D.hide()
	$Dust.emitting = true
	await get_tree().create_timer(1).timeout
	self.queue_free() 


func hidden():
	$PizzaPieceItem.hide()


func vanishes():
	var player = get_tree().current_scene.get_node("%PizzaBoy")
	player.kill_count += 1
	
	$PizzaRadar.queue_free()
	hidden()
	$ZombieFeet.queue_free()
	$DamageArea/CollisionShape2D.queue_free()
	$Sprite2D.hide()
	$Dust.emitting = true
	await get_tree().create_timer(1).timeout
	self.queue_free() 


func drop_pizza_piece():
	var pizza_piece_item = pizza_piece_scene.instantiate()
	pizza_piece_item.position = position
	pizza_piece_item.set_rotation_degrees(randi_range(0, 360))
	get_tree().get_root().call_deferred("add_child", pizza_piece_item)


func move_to_pizza(delta):
	anim_player.play("walk")
	var new_position = position.move_toward(
		found_pizza_piece_position, 
		walking_speed * delta
	)
	position = new_position


func _on_damage_area_area_entered(area):
	var body = area.get_parent()
	
	if area.is_in_group("pizza_piece"):
		get_pizza_from_ground(area)
	
	if body.is_in_group("player"):
		get_pizza_from_player(body, area)


func get_pizza_from_ground(area):
	if has_pizza_piece == false:
		delete_pizza_piece(area)
		picked_up_pizza()


func delete_pizza_piece(pizza_piece):
		pizza_piece.queue_free()


func get_pizza_from_player(player, player_area):
	if player_area.name != "HitDetection": return
	if player.pizza_pieces == 0: return
	if has_pizza_piece == false:
		player.lose_piece(1)
		picked_up_pizza()


func picked_up_pizza():
	$PizzaPieceItem.visible = true
	$Haha.rplay()
	$Stole.play()
	has_pizza_piece = true
