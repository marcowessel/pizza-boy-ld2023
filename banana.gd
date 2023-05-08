extends Node2D

func _ready():
	var random = randi_range(0, 1)
	if random == 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func _on_area_2d_body_entered(body):
	if body.name == "PizzaBoy":
		body.slip()
		$slip.play()
		$AnimationPlayer.play("vanish")
		$Dust.emitting = true
		await get_tree().create_timer(1).timeout
		self.queue_free()
