extends Camera2D

var player
var follow_active = true

func _ready():
	player = get_node("%PizzaBoy")

func _process(_delta):
	if(follow_active):
		camera_follows_player()
	
func camera_follows_player():
	set_global_position(player.global_position)
	
func set_follow_active(active:bool):
	follow_active = active
