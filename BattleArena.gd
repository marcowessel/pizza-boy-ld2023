extends Node2D

var total_zombie_amount
var player

func _ready():
	var node = get_tree().current_scene.get_node("EnemySpawner")
	total_zombie_amount = node.total_zombies
	player = get_parent().get_node("PizzaBoy")


func _physics_process(_delta):
	# only disable once
	if player.kill_count >= total_zombie_amount:
		disable_battlezone()


func disable_battlezone():
	print("disable battlezone")
	var battle_arena_trigger = get_node("BattleArenaTrigger")
	battle_arena_trigger.enable_camera_movement()
	battle_arena_trigger.deactivate_barricades()
