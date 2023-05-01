extends Node2D

@export var in_animation = false

func _ready():
	$Tutorial/RichTextLabel.hide()
	$BattleArena/RichTextLabel.hide()
	$End/RichTextLabel.hide()
	#$PizzaBoy/PlayerHUD.hide()
	$Tutorial_Song.play()
	#$PizzaBoy.is_in_custcene = true

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

	
# WORKING ON
#- [x] 3 zombie waves with increasing difficulty
#- [x] merge jona stand
#- [x] if all mobs are cleared baricades vanishes
#- [x] activate camera follow again (smooth transition on player)
#- [x] Pizza detection pizza zombies for droped pizza pieces (area2d)
#- [] pizza zombies go for pizza pieces in range


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
#- [x] if enemy has pizza piece, he cant steal more
#- [] make small cooldown for lightattack so it cant be spammed


# BACKLOG
#- [] 
