extends CharacterBody2D

@export var speed = 400
@export var pizza_slices = 6 # represents the amount of health
@export var light_attack_distance = 70
@export var light_attack_duration:float = 0.2

var delivery_bag_back
var delivery_bag_back_default
var is_walking = false # is the player walking
var anim_player
var bike # reference to the bicycle node
var is_on_bike = false # whether the player is currently riding the bike or not
var bike_timer = 0 # timer for the duration of the bike power-up
var pizza_meter = 0 # current value of the pizza meter

const MAX_PIZZA_METER = 100 # maximum value of the pizza meter
const BIKE_DURATION = 7 # duration of the bike power-up in seconds
const BIKE_DEPLETION = 100 # amount the pizza meter depletes when the bike power-up is used

func _ready():
	delivery_bag_back = get_node("%DeliveryBagBack")
	delivery_bag_back_default = delivery_bag_back.duplicate()

	anim_player = get_node("AnimationPlayer")
	bike = get_node("Bike")
	bike.hide()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	
func _process(_delta):
	get_input()
	move_and_slide()

	if velocity.length_squared() > 0 and !is_on_bike:
		if !is_walking:
			anim_player.play("walk")
			is_walking = true
	else:
		if is_walking:
			anim_player.play("idle")
			is_walking = false
	if get_global_mouse_position().x > position.x: # Flips Sprite at mouse
		$Sprite2D.flip_h = false
		$Bike.flip_h = false
	else:
		$Sprite2D.flip_h = true
		$Bike.flip_h = true
	#look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("space"): #and pizza_meter >= MAX_PIZZA_METER:
		if !is_on_bike:
			# show the bicycle node and double the movement speed
			bike.show()
			anim_player.play("bike_drive")
			is_on_bike = true
			speed *= 2
			# start the timer for the duration of the bike power-up
			bike_timer = BIKE_DURATION
			# deplete the pizza meter when the bike power-up is used
			pizza_meter -= BIKE_DEPLETION
		else:
			# hide the bicycle node and reset the movement speed
			bike.hide()
			is_on_bike = false
			speed /= 2

func _input(event):
	#TODO make small cooldown so it cant be spammed
	if event.is_action_pressed("click"):
		light_attack()
	
	
func light_attack():
	var cursor_position = get_global_mouse_position()
	
	setup_delivery_bag(cursor_position)
	var attack_vector = calculate_attack_vector(cursor_position)
	
	# move 
	delivery_bag_back.position += attack_vector
	await get_tree().create_timer(light_attack_duration).timeout
	print("timer")
	
	# reset delivery bag
	delivery_bag_back.position = delivery_bag_back_default.position
	delivery_bag_back.set_z_index(-1)
	delivery_bag_back.rotation = delivery_bag_back_default.rotation


	# - take a fixed distance beetween the player and the cursor
	
	# - activate damage, with the collider 
	
	# - move bag to that point smoothly (tween)
	
	# - 
	
	print("light attack")
	
func setup_delivery_bag(cursor_position):
	delivery_bag_back.position = Vector2(0, 0) #center on player
	delivery_bag_back.set_z_index(10) #bring to front
	delivery_bag_back.look_at(cursor_position) #setup attack angle
	
func calculate_attack_vector(cursor_position):
	var start_position = delivery_bag_back.global_position
	var direction_vector = cursor_position - start_position
	var normalized_direction_vector = direction_vector.normalized()
	
	return normalized_direction_vector * light_attack_distance
