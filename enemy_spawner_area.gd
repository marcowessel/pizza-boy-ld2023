extends Area2D

var pizza_zombie_scene = preload("res://Characters/pizza_zombie.tscn")
var pizza_runner_scene = preload("res://Characters/pizza_runner.tscn")
var pizza_dummy_scene = preload("res://Characters/pizza_dummy.tscn")

# Wave 1
@export var wave1_amount_enemys = 3 #3 
@export var wave1_spawn_time_randomnes:Vector2 = Vector2(2, 4)
@export var wave1_walking_speed_random_range:Vector2 = Vector2(50, 100)

# Wave 2
@export var wave2_amount_enemys = 6 #6
@export var wave2_spawn_time_randomnes:Vector2 = Vector2(2, 3)
@export var wave2_walking_speed_random_range:Vector2 = Vector2(100, 150)

# Wave 3
@export var wave3_amount_enemys = 9 #9
@export var wave3_spawn_time_randomnes:Vector2 = Vector2(1, 2)
@export var wave3_walking_speed_random_range:Vector2 = Vector2(150, 200)

# Wave 4
@export var wave4_amount_enemys = 12 #12
@export var wave4_spawn_time_randomnes:Vector2 = Vector2(1, 1.7)
@export var wave4_walking_speed_random_range:Vector2 = Vector2(200, 200)

# Wave 5 Ultimate 
@export var wave5_amount_enemys = 15 #15
@export var wave5_spawn_time_randomnes:Vector2 = Vector2(1, 1.5)
@export var wave5_walking_speed_random_range:Vector2 = Vector2(200, 250)

# Wave 6 Ultra Deluxe 
@export var wave6_amount_enemys = 18 #18
@export var wave6_spawn_time_randomnes:Vector2 = Vector2(1, 1.5)
@export var wave6_walking_speed_random_range:Vector2 = Vector2(210, 260)

var total_zombies = (
	wave1_amount_enemys + 
	wave2_amount_enemys + 
	wave3_amount_enemys + 
	wave4_amount_enemys + 
	wave5_amount_enemys +
	wave6_amount_enemys
) * 2

#var total_zombies = (wave1_amount_enemys) * 2#TEST


func _ready():
	print("total zombies: ", total_zombies)
	self.add_to_group("enemy_spawner")


func activate_spawner():
	wave(
		wave1_amount_enemys,
		wave1_spawn_time_randomnes,
		wave1_walking_speed_random_range
	)

	await get_tree().create_timer(12).timeout #12

	wave(
		wave2_amount_enemys,
		wave2_spawn_time_randomnes,
		wave2_walking_speed_random_range
	)

	await get_tree().create_timer(15).timeout #15

	wave(
		wave3_amount_enemys,
		wave3_spawn_time_randomnes,
		wave3_walking_speed_random_range
	)
	
	await get_tree().create_timer(15).timeout #15

	get_parent().get_node("Banana_Animation").play("2nd_phase")
	wave(
		wave4_amount_enemys,
		wave4_spawn_time_randomnes,
		wave4_walking_speed_random_range
	)
	
	await get_tree().create_timer(17).timeout #17

	wave(
		wave5_amount_enemys,
		wave5_spawn_time_randomnes,
		wave5_walking_speed_random_range
	)

	await get_tree().create_timer(20).timeout #20

	get_parent().get_node("Banana_Animation").play("3rd_phase")
	wave(
		wave6_amount_enemys,
		wave6_spawn_time_randomnes,
		wave6_walking_speed_random_range
	)


func wave(amount_enemys, time_range, speed_range):
	for i in range(amount_enemys):
		await spawn_zombie(time_range, speed_range)


func spawn_zombie(time_range, speed_range):
	var pizza_zombie = pizza_zombie_scene.instantiate()
	var pizza_runner = pizza_runner_scene.instantiate()
	var pizza_dummy = pizza_dummy_scene.instantiate()
	var random = randi_range(0, 7)
	var random_spawn_position = get_random_spawner_position()

	pizza_zombie.walking_speed = randf_range(
		speed_range.x,
		speed_range.y
	)

	pizza_runner.walking_speed = randf_range(
		speed_range.x * 1.3,
		speed_range.y * 1.3
	)
	
	pizza_dummy.walking_speed = randf_range(
		speed_range.x * 0.6,
		speed_range.y * 0.6
	)

	pizza_zombie.spawn_position = random_spawn_position
	pizza_zombie.position = random_spawn_position
	
	pizza_runner.spawn_position = random_spawn_position
	pizza_runner.position = random_spawn_position
	
	pizza_dummy.spawn_position = random_spawn_position
	pizza_dummy.position = random_spawn_position
	
	if random < 5:
		print(random)
		get_owner().add_child.call_deferred(pizza_zombie)
	elif random >= 5 and !random == 7:
		print(random)
		get_owner().add_child.call_deferred(pizza_runner)
	elif random == 7:
		print(random)
		get_owner().add_child.call_deferred(pizza_dummy)

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
	if !area.is_in_group("hitbox"): return
	if body.has_pizza_piece:
		body.vanishes()
