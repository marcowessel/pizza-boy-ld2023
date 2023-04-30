extends CharacterBody2D

@export var speed = 400
@export var pizza_slices = 6 # represents the amount of health
@export var deliveryBag:PackedScene

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
	#TODO
	# - collider initialisieren in richtung des cursors 
	var instance = deliveryBag.instantiate()
	
	# -fix error
	#instance.position = $Sprite.position + $Sprite.global_transform.basis_x * 32
	
	add_child(instance)
	
	print("attack")
	
	
	


