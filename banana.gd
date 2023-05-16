extends Node2D

func _ready():
	var random = randi_range(0, 1)
	if random == 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false

func _on_area_2d_body_entered(body):
	if body.name == "PizzaBoy":
		if !body.is_on_bike:
			body.slip()
			$slip.play()
			$AnimationPlayer.play("vanish")
			$Dust.emitting = true
			await get_tree().create_timer(1).timeout
			self.queue_free()

func activate():
	$Area2D/CollisionShape2D.disabled = false

func deactivate():
	self.hide()
	$Area2D/CollisionShape2D.disabled = true

func floor_hit():
	$fall.play()
