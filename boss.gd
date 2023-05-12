extends CharacterBody2D

@export var health:int = 100
@export var walking_speed = 100

var is_activated = false
var player
var is_dead = false


func _ready():
	self.add_to_group("destructable")


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
		is_dead = true
		is_activated = false
		print("boss dead")
		$AnimationPlayer.play("die")
		get_owner().credits()
		get_owner().get_node("PizzaBoy/AnimationPlayer").play("idle")
		self.z_index = -1


func activate():
	print("boss activated")
	player = get_node("%PizzaBoy")
	is_activated = true


func _process(delta):
	if is_activated:
		$AnimationPlayer.play("walk")
		run_towards_player(delta)


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
	else:
		$Sprite2D.flip_h = false
