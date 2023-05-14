extends EnemyBase


func _ready():
	health = 10


func dies(): # override
	$Destruction.play()
	$CollisionShape2D.queue_free()
	$Area2D/CollisionShape2D.queue_free()
	$Sprite2D.hide()
	$Dust.emitting = true
	await get_tree().create_timer(1.0).timeout
	
	super()
