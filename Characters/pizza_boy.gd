extends CharacterBody2D

@export var speed = 400
@export var pizza_slices = 6 # represents the amount of health
#@export var delivery_bag:PackedScene
var delivery_bag_back
var delivery_bag_back_default_pos

func _ready():
	delivery_bag_back = get_node("%DeliveryBagBack")
	delivery_bag_back_default_pos = delivery_bag_back.position

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func _process(_delta):
	get_input()
	move_and_slide()
	#look_at(get_global_mouse_position())

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
