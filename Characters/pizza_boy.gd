extends CharacterBody2D

@export var max_pizza_pieces = 8
@export var pizza_pieces:int # represents the amount of health
@export var movement_speed = 400
@export var light_attack_damage = 2
@export var light_attack_distance = 90
@export var light_attack_duration:float = 0.2
@export var is_in_custcene = false

var attack_state = ATTACK_STATE.NONE
var delivery_bag_back
var delivery_bag_back_default
var delivery_bag_back_collision

var is_walking = false
var anim_player
var bike
var is_on_bike = false 
var pizza_meter
var timer
var spacebar
var bike_song_started = false

enum ATTACK_STATE {
	NONE,
	LIGHT_ATTACK
}


func _ready():
	self.add_to_group("player")
	pizza_pieces = max_pizza_pieces
	delivery_bag_back = get_node("%DeliveryBagBack")
	delivery_bag_back_default = delivery_bag_back.duplicate()
	delivery_bag_back_collision = $DeliveryBagBack/DeliveryBagDamageArea
	pizza_meter = $PlayerHUD/ProgressBar
	timer = $Bike_Timer
	spacebar = $PlayerHUD/Spacebar

	anim_player = get_node("AnimationPlayer")
	bike = get_node("Bike")
	bike.hide()
	
	
func _process(_delta):
	if !is_in_custcene:
		get_input()
		move_and_slide()
		bike_logic()
		if pizza_meter.value == 100:
			spacebar.show()
			spacebar.play("default")
	

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * movement_speed	


func lose_piece():
	var hud_pizza_pieces = $PlayerHUD/PizzaPieces
	hud_pizza_pieces.remove_piece()
	pizza_pieces -= 1
	
	if pizza_pieces <= 0: player_death()
	
func player_death():
	print("player dead")
	
	
func pickup_piece():
	if pizza_pieces < max_pizza_pieces:
		var hud_pizza_pieces = $PlayerHUD/PizzaPieces
		hud_pizza_pieces.add_piece()
		pizza_pieces += 1


func bike_logic():
	if !is_in_custcene:
		if velocity.length_squared() > 0 and !is_on_bike:
			if !is_walking and !is_on_bike:
				anim_player.play("walk")
				is_walking = true
		elif is_walking and !is_on_bike:
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
				# show the bicycle node and double the movement speed
				if !bike_song_started:
					get_parent().get_node("Bike_Song").play()
					bike_song_started = true
				get_parent().get_node("Combat_Music").volume_db = -80
				get_parent().get_node("Bike_Song").volume_db = -10
				is_on_bike = true
				is_walking = false
				pizza_meter.value = 0
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
	if event.is_action_pressed("click") and !is_in_custcene:
		light_attack()
	
	
func light_attack():
	attack_state = ATTACK_STATE.LIGHT_ATTACK
	var cursor_position = get_global_mouse_position()
	var attack_vector = calculate_attack_vector(cursor_position)
	
	anim_player.play("throw")
	setup_delivery_bag(cursor_position)
	await execute_attack(attack_vector)

	delivery_bag_reset()
	attack_state = ATTACK_STATE.NONE
	#print(delivery_bag_back.position)
	
	
func setup_delivery_bag(cursor_position):
	delivery_bag_back.position = Vector2(0, 0) #center on player
	delivery_bag_back.set_z_index(10) #bring to front
	delivery_bag_back.look_at(cursor_position) #setup attack angle
	
	
func calculate_attack_vector(cursor_position):
	var start_position = delivery_bag_back.global_position
	var direction_vector = cursor_position - start_position
	var normalized_direction_vector = direction_vector.normalized()
	
	return normalized_direction_vector * light_attack_distance

	
func execute_attack(attack_vector):
	#var tween = create_tween()
	#tween.tween_property(delivery_bag_back, "position", attack_vector, 0.2).set_ease(Tween.EASE_IN)
	$Bag_Throw.rplay()
	delivery_bag_back_collision.disabled = false
	delivery_bag_back.position += attack_vector
	await get_tree().create_timer(light_attack_duration).timeout
	
	
func delivery_bag_reset():
	delivery_bag_back.position = delivery_bag_back_default.position
	#print(delivery_bag_back.position)
	delivery_bag_back.set_z_index(delivery_bag_back_default.z_index)
	delivery_bag_back.rotation = delivery_bag_back_default.rotation
	delivery_bag_back_collision.disabled = true


func _on_delivery_bag_back_area_entered(area):
	var body = area.get_parent()
	
	if body.is_in_group("enemy"):
		deal_damage(body)


func deal_damage(enemy):
	match attack_state:
		ATTACK_STATE.LIGHT_ATTACK:
			enemy.take_damage(light_attack_damage)
			pizza_meter.value += 10
			$Hit.rplay()
		ATTACK_STATE.NONE:
			print("no attack")


func _on_hit_detection_area_entered(area):
	var body = area.get_parent()
	
	if body.is_in_group("enemy"):
		lose_piece()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "throw":
		if !is_walking:
			anim_player.play("idle")
		if is_walking:
			anim_player.play("walk")

func _on_bike_timer_timeout():
	get_parent().get_node("Bike_Song").volume_db = -80
	get_parent().get_node("Combat_Music").volume_db = 5
	$Bike_Loop.stop()
	is_on_bike = false
	movement_speed /= 2
	print(movement_speed)
	bike.hide()
	anim_player.play("idle")

func footstep():
	$Walking.rplay()
