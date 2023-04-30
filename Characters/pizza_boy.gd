extends CharacterBody2D

@export var speed = 400
@export var pizza_slices = 6 # represents the amount of health
var is_walking = false # is the player walking
#@export var delivery_bag:PackedScene
var delivery_bag_back
var delivery_bag_back_default_pos
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
	delivery_bag_back_default_pos = delivery_bag_back.position
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
	if event.is_action_pressed("click"):
		light_attack()
	
func light_attack():
	# TODO
	# - put deliverybag into the center of node
	delivery_bag_back.position = Vector2(0, 0)
	delivery_bag_back.set_z_index(10)
	delivery_bag_back.look_at(get_global_mouse_position())
	
	# - make the bag point to mouse direction
	
	
	# - take a fixed distance beetween the player and the cursor
	
	# - activate damage, with the collider 
	
	# - move bag to that point smoothly (tween)
	
	# - 
	
	
	
	# - collider initialisieren in richtung des cursors 
	#var instance = delivery_bag.instantiate()
	
	# -fix error
	#instance.position = $Sprite.position + $Sprite.global_transform.basis_x * 32
	
	#add_child(instance)
	
	print("light attack")
