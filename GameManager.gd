extends Node2D

func _ready():
	$Tutorial/RichTextLabel.hide()
	$BattleArena/RichTextLabel.hide()
	$End/RichTextLabel.hide()
	$Combat_Music.play()

# WORKING ON
#- [x] 3 zombie waves with increasing difficulty
#- [] merge jona stand
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

#BACKLOG
#- [] "WATCH OUT! PIZZA HOOLIGANS INCOMING" text appears few seconds
#- [] 20 mobs overall split into 3 waves
