extends CharacterBody2D

var pizza_piece_scene = preload("res://pizza_piece_item.tscn") 

@export var health:int = 100
@export var walking_speed = 100

var is_activated = false
var player
var is_dead = false
var has_pizza_piece = false
var hand_active = false
var timer_started = false

func _ready():
	self.add_to_group("destructable")
	player = get_node("%PizzaBoy")

func take_damage(damage):
	if (health - damage <= 0):
		health = 0
		dies()
	else:
		health -= damage
		$CanvasLayer/ProgressBar.value -= damage


func dies():
	if !is_dead:
		#$Dies.play()
		$Hand.hide()
		is_dead = true
		is_activated = false
		print("boss dead")
		$AnimationPlayer.play("die")
		get_owner().credits()
		self.z_index = -1


func activate():
	print("boss activated")
	is_activated = true
	$Hand.show()


func _process(delta):
	if is_activated:
		$AnimationPlayer.play("walk")
		run_towards_player(delta)
		if !has_pizza_piece:
			takes_pizza()
			rotate_hand_to_player()

func takes_pizza():
	if !hand_active and !timer_started:
		timer_started = true
		hand_active = true
		call_deferred("activate_collision")
		$Hand.frame = 0
		$HandTimer.start()
		print("gets here")
		print(hand_active)
	elif hand_active and !timer_started:
		timer_started = true
		hand_active = false
		call_deferred("deactivate_collision")
		$Hand.frame = 1
		$HandTimer.start()
		print("gets here")
		print(hand_active)

func rotate_hand_to_player():
	var direction_to_player = (player.global_position - $Hand.global_position)
	var rad_to_player = atan2(direction_to_player.x, -direction_to_player.y)
	$Hand.rotation = rad_to_player - PI/2


func run_towards_player(delta):
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
		$Hand.flip_v = true
	else:
		$Sprite2D.flip_h = false
		$Hand.flip_v = false


func _on_hand_detection_area_entered(area):
	var body = area.get_parent()
	
	if body.is_in_group("player"):
		get_pizza_from_player(body, area)


func get_pizza_from_player(player, player_area):
	if player_area.name != "HitDetection": return
	if player.pizza_pieces == 0: return
	if has_pizza_piece == false:
		player.lose_piece(1)
		picked_up_pizza()


func picked_up_pizza():
	$Hand/Pizza.show()
	$Hand.frame = 1
	has_pizza_piece = true
	$Schmatz.play()
	call_deferred("deactivate_collision")
	await get_tree().create_timer(1.3).timeout
	$Burp.play()
	$Hand/Pizza.hide()
	await get_tree().create_timer(0.2).timeout
	call_deferred("activate_collision")
	has_pizza_piece = false

func activate_collision():
	$Hand/HandDetection/CollisionShape2D.disabled = false

func deactivate_collision():
	$Hand/HandDetection/CollisionShape2D.disabled = true

func _on_hand_timer_timeout():
	timer_started = false
