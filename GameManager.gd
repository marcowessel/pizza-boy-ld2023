extends Node2D

@export var in_animation = false

func _ready():
	$Tutorial/RichTextLabel.hide()
	$BattleArena/RichTextLabel.hide()
	$End/RichTextLabel.hide()
	$PizzaBoy/PlayerHUD.hide()
	#$PizzaBoy.is_in_custcene = true
	#$Title.show()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "endboss_cutscene":
		$Boss_Song.play()

func accelerate_cutscene():
	if Input.is_action_pressed("speedup") and in_animation:
		$AnimationPlayer.set_speed_scale(3)
		$Tutorial_Song.pitch_scale = 3
	else:
		$AnimationPlayer.set_speed_scale(1)
		$Tutorial_Song.pitch_scale = 1

func _process(delta):
	if in_animation:
		accelerate_cutscene()
	else:
		pass

func start_game():
	$Tutorial_Song.play()
	$AnimationPlayer.play("Startup_Anim")
	$Title.hide()

func _on_texture_button_pressed():
	start_game()

# WORKING ON
#- [x] 3 zombie waves with increasing difficulty
#- [x] merge jona stand
#- [] if all mobs are cleared baricades vanishes
#- [] activate camera follow again (smooth transition on player)
#- [] Pizza detection pizza zombies for droped pizza pieces (area2d)


# TODO
#- [x] crosshair instead of cursor
#- [x] implement light attack
#- [x] baricade left / right activate
#- [x] spawning of mobs, basic "zombies"
#- [] move delivery bag to that point smoothly (tween)
#- [] make small cooldown for lightattack so it cant be spammed
#- [] if enemy has pizza piece, he cant steal more
#- [] backpack should flip with player


# ERRORS
#- [] if enemy has pizza piece, he cant steal more
#- [] make small cooldown for lightattack so it cant be spammed
#- [] pizza piece still shows after player picked it up on a dead zombie
#- [] zombie walk animation doesnt play if he has a pizza piece


# BACKLOG
#- [] "WATCH OUT! PIZZA HOOLIGANS INCOMING" text appears few seconds
#- [] 20 mobs overall split into 3 waves





