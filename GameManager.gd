extends Node2D

@export var in_animation = false

func _ready():
	$Tutorial/RichTextLabel.hide()
	$BattleArena/RichTextLabel.hide()
	$End/RichTextLabel.hide()
	$PizzaBoy/PlayerHUD.hide()
	$PizzaBoy.is_in_custcene = true
	$Title.show()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "endboss_cutscene":
		$Boss.activate()
		$Boss_Song.play()
	elif anim_name == "Startup_Anim":
		if get_node("PizzaBoy").is_walking == false:
			get_node("PizzaBoy/AnimationPlayer").play("idle")
		if get_node("PizzaBoy").is_walking == true:
			get_node("PizzaBoy/AnimationPlayer").play("walk")

func accelerate_cutscene():
	if Input.is_action_pressed("speedup") and in_animation:
		$AnimationPlayer.set_speed_scale(3)
		$Tutorial_Song.pitch_scale = 3
		$Pirate.pitch_scale = 3
	else:
		$AnimationPlayer.set_speed_scale(1)
		$Tutorial_Song.pitch_scale = 1
		$Pirate.pitch_scale = 1

func _process(delta):
	if in_animation:
		accelerate_cutscene()
	else:
		pass

func start_game():
	$Tutorial_Song.play()
	$AnimationPlayer.play("Startup_Anim")
	$PizzaBoy/PlayerHUD.show()
	$Title.hide()

func _on_texture_button_pressed():
	start_game()

func credits():
	$PizzaBoy.is_in_custcene = true
	$Boss_Song.stop()
	$CanvasLayer.show()
	$PizzaBoy/PlayerHUD.hide()
	$Boss/CanvasLayer.hide()
	$Outro.play()
	$AnimationPlayer.play("credits")

func _on_outro_finished():
	get_tree().quit()

# WORKING ON
#- [x] 3 zombie waves with increasing difficulty
#- [x] merge jona stand
#- [x] if all mobs are cleared baricades vanishes
#- [x] activate camera follow again (smooth transition on player)
#- [x] Pizza detection pizza zombies for droped pizza pieces (area2d)
#- [x] pizza zombies go for pizza pieces in range


# TODO
#- [x] crosshair instead of cursor
#- [x] implement light attack
#- [x] baricade left / right activate
#- [x] spawning of mobs, basic "zombies"
#- [] move delivery bag to that point smoothly (tween)
#- [x] make small cooldown for lightattack so it cant be spammed
#- [] if enemy has pizza piece, he cant steal more
#- [] backpack should flip with player


# ERRORS
#- [x] if enemy has pizza piece, he cant steal more
#- [x] make small cooldown for lightattack so it cant be spammed


# BACKLOG
#- []


