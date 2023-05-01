extends Camera2D

var player
var follow_active = true


func _ready():
	player = get_node("%PizzaBoy")
	set_global_position(player.global_position)


func _process(delta):
	if(follow_active):
		camera_follows_player(delta)


func camera_follows_player(delta):
	var target_position = player.global_position
	
	set_global_position(position.move_toward(
		target_position, 
		1000 * delta
	))


func set_follow_active(active:bool):
	follow_active = active
