extends Area2D

var pizza_zombie_scene = preload("res://Characters/pizza_zombie.tscn")

# Wave 1
@export var wave1_amount_enemys = 2
@export var wave1_spawn_time_randomnes:Vector2 = Vector2(2, 4)
@export var wave1_walking_speed_random_range:Vector2 = Vector2(50, 100)

# Wave 2
@export var wave2_amount_enemys = 6
@export var wave2_spawn_time_randomnes:Vector2 = Vector2(1, 3)
@export var wave2_walking_speed_random_range:Vector2 = Vector2(100, 150)

# Wave 3
@export var wave3_amount_enemys = 10
@export var wave3_spawn_time_randomnes:Vector2 = Vector2(1, 2)
@export var wave3_walking_speed_random_range:Vector2 = Vector2(150, 200)

var total_zombies = (wave1_amount_enemys + wave2_amount_enemys + wave3_amount_enemys) * 2

func _ready():
	self.add_to_group("enemy_spawner")


func activate_spawner():
	wave(
		wave1_amount_enemys,
		wave1_spawn_time_randomnes,
		wave1_walking_speed_random_range
	)
	
	await get_tree().create_timer(12).timeout
	
	wave(
		wave2_amount_enemys,
		wave2_spawn_time_randomnes,
		wave2_walking_speed_random_range
	)
	
	await get_tree().create_timer(15).timeout
	
	wave(
		wave3_amount_enemys,
		wave3_spawn_time_randomnes,
		wave3_walking_speed_random_range
	)


func wave(amount_enemys, time_range, speed_range):
	for i in range(amount_enemys):
		await spawn_zombie(time_range, speed_range)


func spawn_zombie(time_range, speed_range):
	var pizza_zombie = pizza_zombie_scene.instantiate()
	var random_spawn_position = get_random_spawner_position()
	
	pizza_zombie.walking_speed = randf_range(
		speed_range.x, 
		speed_range.y
	)
	
	pizza_zombie.spawn_position = random_spawn_position
	pizza_zombie.position = random_spawn_position
	
	get_owner().add_child.call_deferred(pizza_zombie)
	
	await get_tree().create_timer(randf_range(
		time_range.x, 
		time_range.y
	)).timeout


func get_random_spawner_position():
	var random_position = position
	random_position.y += randi_range(-330, 330)	 #660px height collider
	
	return random_position


func _on_area_entered(area):
	var body = area.get_parent()
	if !body.is_in_group("enemy"): return
	if body.has_pizza_piece:
		body.vanishes()
		
