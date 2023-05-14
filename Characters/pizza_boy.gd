extends CharacterBody2D

@export var max_pizza_pieces = 8
@export var pizza_pieces:int # represents the amount of health
@export var movement_speed = 400
@export var light_attack_damage = 2
@export var heavy_attack_damage = 6
@export var light_attack_distance = 90
@export var heavy_attack_distance = 120
@export var bike_damage = 10
@export var spin_damage = 2
@export var light_attack_duration:float = 0.2
@export var heavy_attack_duration:float = 0.3
@export var is_in_custcene = false
@export var is_walking = false

var attack_state = ATTACK_STATE.NONE
var kill_count = 0
var delivery_bag_back
var delivery_bag_back_default
var delivery_bag_back_collision
var delivery_bag_heavy_collision
var spin_flash
var spin_timer

var anim_player
var bike
var is_on_bike = false
var pizza_meter
var timer
var spacebar
var bike_song_started = false
var reached_full_capacity = false
var is_dead = false
var attack_cooldown = false
var spin_cooldown = false
var is_spinning = false
var is_charging = false

enum ATTACK_STATE {
	NONE,
	LIGHT_ATTACK,
	STRONG_ATTACK,
	SPIN_ATTACK,
	BIKE_ATTACK
}


func _ready():
	self.add_to_group("player")
	pizza_pieces = max_pizza_pieces
	delivery_bag_back = get_node("%DeliveryBagBack")
	delivery_bag_back_default = delivery_bag_back.duplicate()
	delivery_bag_back_collision = $DeliveryBagBack/DeliveryBagDamageArea
	delivery_bag_heavy_collision = $DeliveryBagBack/HeavyDamageArea
	spin_flash = get_node("%SpinFlash")
	pizza_meter = $PlayerHUD/ProgressBar
	timer = $Bike_Timer
	spacebar = $PlayerHUD/Spacebar
	spin_timer = $Spin_Duration

	anim_player = get_node("AnimationPlayer")
	bike = get_node("Bike")
	bike.hide()


func _process(_delta):
	if !is_in_custcene:
		get_input()
		move_and_slide()
		bike_logic()
		if pizza_meter.value == 100:
			if !reached_full_capacity:
				spacebar.show()
				spacebar.play("default")
				$Pizza_Meter.play()
				reached_full_capacity = true

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * movement_speed


func player_death():
	if !is_dead:
		if is_spinning:
			call_deferred("break_attack")
		is_dead = true
		is_in_custcene = true
		$GameOver.play()
		$AnimationPlayer.play("die")
		get_owner().get_node("Combat_Music").stop()
		get_owner().get_node("Boss_Song").stop()
		deactivate_enemy_animation()
		await get_tree().create_timer(5).timeout
		get_tree().reload_current_scene()


func deactivate_enemy_animation():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.stop_animation()


func pickup_piece():
	if pizza_pieces < max_pizza_pieces:
		$Pickup.play()
		var hud_pizza_pieces = $PlayerHUD/PizzaPieces
		hud_pizza_pieces.add_piece()
		pizza_pieces += 1


func bike_logic():
	if !is_in_custcene:
		if velocity.length_squared() > 0 and !is_on_bike and !is_spinning:
			if !is_walking and !is_on_bike:
				anim_player.play("walk")
				is_walking = true
		elif is_walking and !is_on_bike and !is_spinning:
			anim_player.play("idle")
			is_walking = false

		if get_global_mouse_position().x > position.x: # Flips Sprite at mouse
			$Player.flip_h = false
			$Bike.flip_h = false
		else:
			$Player.flip_h = true
			$Bike.flip_h = true
		#look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("space") and pizza_meter.value == 100: #and pizza_meter >= MAX_PIZZA_METER:
			if !is_on_bike:
				if is_spinning:
					call_deferred("break_attack")
				# show the bicycle node and double the movement speed
				attack_state = ATTACK_STATE.BIKE_ATTACK
				call_deferred("_activate")
				if !bike_song_started:
					get_parent().get_node("Bike_Song").play()
					bike_song_started = true
				get_parent().get_node("Combat_Music").volume_db = -80
				get_parent().get_node("Boss_Song").volume_db = -80
				get_parent().get_node("Bike_Song").volume_db = -10
				is_on_bike = true
				is_walking = false
				pizza_meter.value = 0
				reached_full_capacity = false
				bike.show()
				$Bike_Ring.rplay()
				$Bike_Loop.play()
				anim_player.play("bike_drive")
				spacebar.hide()
				movement_speed *= 2
				# start the timer for the duration of the bike power-up
				timer.start()
				# deplete the pizza meter when the bike power-up is used


func _input(event):
	if !is_on_bike:
		if event.is_action_pressed("click") and !is_in_custcene:
			if !attack_cooldown:
				$Charge_Anim.play("charge")
		elif event.is_action_pressed("spin") and !is_in_custcene and !is_spinning:
			if !spin_cooldown:
				spin_attack()
		elif event.is_action_released("click") and !is_in_custcene:
			if $Charge_Anim.is_playing() and $Charge_Anim.current_animation == "charge":
				light_attack()
				$Charge_Anim.stop()
			elif $Player.use_parent_material == false:
				strong_attack()

func cancel_attack():
	anim_player.play("cancel_attack")


func light_attack():
	if !is_spinning:
		attack_state = ATTACK_STATE.LIGHT_ATTACK
		var cursor_position = get_global_mouse_position()
		var attack_vector = calculate_attack_vector(cursor_position)
		$DeliveryBagBack/DeliveryBag.show()
		$DeliveryBagBack/HeavyFlash.hide()

		anim_player.play("throw")
		setup_delivery_bag(cursor_position)
		await execute_attack(attack_vector)

		delivery_bag_reset()
		attack_state = ATTACK_STATE.NONE


func strong_attack():
	if !is_spinning:
		attack_state = ATTACK_STATE.STRONG_ATTACK
		var cursor_position = get_global_mouse_position()
		var attack_vector = calculate_heavy_attack_vector(cursor_position)
		$DeliveryBagBack/DeliveryBag.hide()
		$DeliveryBagBack/HeavyFlash.show()

		anim_player.play("throw")
		setup_delivery_bag(cursor_position)
		await execute_strong_attack(attack_vector)

		delivery_bag_reset()
		attack_state = ATTACK_STATE.NONE


func setup_delivery_bag(cursor_position):
	delivery_bag_back.position = Vector2(0, 0) #center on player
	delivery_bag_back.set_z_index(10) #bring to front
	delivery_bag_back.look_at(cursor_position) #setup attack angle


func calculate_attack_vector(cursor_position):
	var start_position = delivery_bag_back.global_position
	var direction_vector = cursor_position - start_position
	var normalized_direction_vector = direction_vector.normalized()

	return normalized_direction_vector * light_attack_distance


func calculate_heavy_attack_vector(cursor_position):
	var start_position = delivery_bag_back.global_position
	var direction_vector = cursor_position - start_position
	var normalized_direction_vector = direction_vector.normalized()

	return normalized_direction_vector * light_attack_distance


func execute_attack(attack_vector):
	$Hit_Timer.start()
	attack_cooldown = true
	delivery_bag_back.show()
	$Flash_Anim.play("scale")
	$Bag_Throw.rplay()
	delivery_bag_back_collision.disabled = false
	delivery_bag_back.position += attack_vector
	await get_tree().create_timer(light_attack_duration).timeout


func execute_strong_attack(attack_vector):
	$Player.use_parent_material = true
	$Hit_Timer.start()
	attack_cooldown = true
	delivery_bag_back.show()
	$Flash_Anim.play("heavy_scale")
	$Heavy_Hit.play()
	delivery_bag_heavy_collision.disabled = false
	delivery_bag_back.position += attack_vector
	await get_tree().create_timer(heavy_attack_duration).timeout


func delivery_bag_reset():
	delivery_bag_back.position = delivery_bag_back_default.position
	delivery_bag_back.set_z_index(delivery_bag_back_default.z_index)
	delivery_bag_back.rotation = delivery_bag_back_default.rotation
	delivery_bag_back_collision.disabled = true
	delivery_bag_heavy_collision.disabled = true
	delivery_bag_back.hide()


func spin_attack():
	if !spin_cooldown:
		attack_state = ATTACK_STATE.SPIN_ATTACK
		$Spin_Cooldown.start()
		spin_timer.start()
		spin_cooldown = true
		is_spinning = true
		spin_flash.show()
		call_deferred("activate_spin_colision")
		anim_player.play("spin")
		$Spin_Anim.play("spin_flash")
		$SpinSound.play()


func activate_spin_colision():
	$SpinFlash/CollisionShape2D.disabled = false
	$SpinFlash/CollisionShape2D2.disabled = false


#Light Attack Colision Check
func _on_delivery_bag_back_area_entered(area):
	var body = area.get_parent()

	if area.is_in_group("hitbox") or body.is_in_group("destructable"):
		deal_damage(body)


#Bike Attack Colision Check
func _on_area_2d_area_entered(area):
	var body = area.get_parent()
	attack_state = ATTACK_STATE.BIKE_ATTACK

	if area.is_in_group("hitbox") or body.is_in_group("destructable"):
		deal_damage(body)


#Spin Attack Colision Check
func _on_spin_flash_area_entered(area):
	var body = area.get_parent()
	attack_state = ATTACK_STATE.SPIN_ATTACK

	if area.is_in_group("hitbox") or body.is_in_group("destructable"):
		deal_damage(body)


func deal_damage(enemy):
	match attack_state:
		ATTACK_STATE.LIGHT_ATTACK:
			enemy.take_damage(light_attack_damage)
			pizza_meter.value += 10
			$Hit.rplay()
		ATTACK_STATE.STRONG_ATTACK:
			enemy.take_damage(heavy_attack_damage)
			pizza_meter.value += 15
			$Hit.rplay()
		ATTACK_STATE.BIKE_ATTACK:
			enemy.take_damage(bike_damage)
			$Hit.rplay()
		ATTACK_STATE.SPIN_ATTACK:
			enemy.take_damage(spin_damage)
			pizza_meter.value += 5
			$Hit.rplay()
		ATTACK_STATE.NONE:
			print("no attack")


func lose_piece(pizza_loss):
	var hud_pizza_pieces = $PlayerHUD/PizzaPieces
	hud_pizza_pieces.remove_piece(pizza_loss)
	pizza_pieces -= pizza_loss
	Score.combo = 0
	if !is_spinning:
		anim_player.play("hurt")

	if pizza_pieces <= 0: player_death()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "throw" or anim_name == "hurt" or anim_name == "standup" or anim_name == "idle" or anim_name == "cancel_attack":
		if !is_walking:
			anim_player.play("idle")
		if is_walking:
			anim_player.play("walk")


func _on_bike_timer_timeout():
	attack_state = ATTACK_STATE.NONE
	call_deferred("_deactivate")
	get_parent().get_node("Bike_Song").volume_db = -80
	get_parent().get_node("Boss_Song").volume_db = 0
	get_parent().get_node("Combat_Music").volume_db = 5
	$Bike_Loop.stop()
	is_on_bike = false
	movement_speed /= 2
	bike.hide()
	anim_player.play("idle")


func footstep():
	$Walking.rplay()


func unhide():
	$PlayerHUD/RichTextLabel.show()
	await get_tree().create_timer(2).timeout
	$PlayerHUD/RichTextLabel.hide()


func _deactivate():
	$Bike/Area2D/Bike_Colision.disabled = true
	$HitDetection/CollisionShape2D.disabled = false


func _activate():
	$Bike/Area2D/Bike_Colision.disabled = false
	$HitDetection/CollisionShape2D.disabled = true


func _on_hit_timer_timeout():
	attack_cooldown = false


func slip():
	call_deferred("disable_movement")
	anim_player.play("falling")
	$Knocked_Timer.start()
	if is_spinning:
		call_deferred("break_attack")


func _on_knocked_timer_timeout():
	anim_player.play("standup")
	await get_tree().create_timer(0.3).timeout
	is_in_custcene = false


func disable_movement():
	is_in_custcene = true


func _on_spin_cooldown_timeout():
	spin_cooldown = false


func _on_spin_duration_timeout():
	call_deferred("end_spin_attack")
	if !is_on_bike:
		anim_player.play("idle")


func end_spin_attack():
	if is_spinning:
		spin_timer.stop()
		$SpinFlash/CollisionShape2D.disabled = true
		$SpinFlash/CollisionShape2D2.disabled = true
		spin_flash.hide()
		is_spinning = false
