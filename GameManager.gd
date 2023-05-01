extends Node2D

func _ready():
	$Tutorial/RichTextLabel.hide()
	$BattleArena/RichTextLabel.hide()
	$End/RichTextLabel.hide()
	$Combat_Music.play()


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


# ERRORS
#- [] if enemy has pizza piece, he cant steal more
#- [] make small cooldown for lightattack so it cant be spammed
#- [] pizza piece still shows after player picked it up on a dead zombie
#- [] zombie walk animation doesnt play if he has a pizza piece


# BACKLOG
#- [] "WATCH OUT! PIZZA HOOLIGANS INCOMING" text appears few seconds
#- [] 20 mobs overall split into 3 waves
