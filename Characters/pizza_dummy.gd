extends EnemyBaseDynamic


func _ready():
	health = 8
	walking_speed = 100
	score_count = 40
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
	if has_pizza_piece: drop_pizza_piece(2)
	await death_visuals()
	self.queue_free() 


func vanishes(): # override
	super()
	self.queue_free() 


func _on_damage_area_area_entered(area):
	interaction(area)


func pizza_from_player(): # override
	player.lose_piece(2)
	super()


func picked_up_pizza(): # override
	#TODO if haha sound is there delete this override
	$PizzaPieceItem.visible = true
	#$Haha.rplay()
	$Pizza.play()
	$Stole.play()
	has_pizza_piece = true
