class_name EnemyBaseDynamic

extends EnemyBase

var pizza_piece_scene = preload("res://pizza_piece_item.tscn")

@export var walking_speed:int
@export var score_count:int

var is_dead = false
var spawn_position:Vector2 = Vector2.ZERO
var player = null
var has_pizza_piece = false
var found_pizza_piece = false
var found_pizza_piece_position = Vector2.ZERO
var anim_player


func _init():
	self.add_to_group("enemy")


func stop_animation():
	anim_player.stop()


func run_towards_player(delta):
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


func move_to_pizza(delta):
	anim_player.play("walk")
	var new_position = position.move_toward(
		found_pizza_piece_position, 
		walking_speed * delta
	)
	position = new_position


func found_pizza_indicator():
	if found_pizza_piece:
		#TODO audio clip found pizza
		$Exclamation_Mark.show()
	else:
		$Exclamation_Mark.hide()


func choose_move(delta):
	if !has_pizza_piece and !is_dead and !found_pizza_piece:
		run_towards_player(delta)
	elif has_pizza_piece and !is_dead:
		run_away(delta)
	elif !has_pizza_piece and found_pizza_piece:
		move_to_pizza(delta)


func dies():
	is_dead = true
	player.kill_count += 1
	Score.combo += 1
	Score.score += score_count * Score.combo
	$PizzaRadar.queue_free()
	$ZombieFeet.queue_free()
	$Death.rplay()
	$Score_Anim.play("score")
	anim_player.play("death")
	$DamageArea/CollisionShape2D.queue_free()
	$Sprite2D.z_index -= 1
	$PizzaPieceItem.hide()


func death_visuals():
	await get_tree().create_timer(2).timeout
	$Sprite2D.hide()
	$Dust.emitting = true
	await get_tree().create_timer(1).timeout


func drop_pizza_piece(pizza_pieces):
	for i in range(pizza_pieces):
		var pizza_piece_item = pizza_piece_scene.instantiate()
		pizza_piece_item.position = position + get_random_offset(5)
		pizza_piece_item.set_rotation_degrees(randi_range(0, 360))
		get_tree().get_root().call_deferred("add_child", pizza_piece_item)


func get_random_offset(amount):
	var x_offset = randi_range(-amount, amount)
	var y_offset = randi_range(-amount, amount)
	var offset = Vector2(x_offset, y_offset)
	
	return offset;


func vanishes():
	player.kill_count += 1
	
	$PizzaRadar.queue_free()
	$PizzaPieceItem.hide()
	$ZombieFeet.queue_free()
	$DamageArea/CollisionShape2D.queue_free()
	$Sprite2D.hide()
	$Dust.emitting = true
	await get_tree().create_timer(1).timeout


func interaction(area):
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
		pizza_from_player()


func pizza_from_player():
	picked_up_pizza()


func picked_up_pizza():
	$PizzaPieceItem.visible = true
	$Haha.rplay()
	$Stole.play()
	has_pizza_piece = true
