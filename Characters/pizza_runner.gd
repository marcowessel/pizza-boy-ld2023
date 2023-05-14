extends EnemyBaseDynamic

func _ready():
	health = 4
	walking_speed = 200
	score_count = 20
	anim_player = $AnimationPlayer
	player = get_tree().current_scene.get_node("%PizzaBoy")
	$PizzaPieceItem/CollisionShapeDamage.queue_free()


func _process(delta):
	found_pizza_indicator()
	choose_move(delta)


func takes_damage(): # override
	$Hurt.rplay()


func dies(): # override
	super()
	if has_pizza_piece: drop_pizza_piece(1)
	await death_visuals()
	self.queue_free() 


func vanishes(): # override
	super()
	self.queue_free() 


func _on_damage_area_area_entered(area):
	interaction(area)


func pizza_from_player(): # override
	player.lose_piece(1)
	super()
