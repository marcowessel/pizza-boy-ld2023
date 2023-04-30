extends CharacterBody2D

@export var speed = 400
@export var pizza_slices = 6 # represents the amount of health
@export var light_attack_distance = 70
@export var light_attack_duration:float = 0.2

var delivery_bag_back
var delivery_bag_back_default


func _ready():
	delivery_bag_back = get_node("%DeliveryBagBack")
	delivery_bag_back_default = delivery_bag_back.duplicate()
	
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
	
func _process(_delta):
	get_input()
	move_and_slide()


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
