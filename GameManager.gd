extends Node2D

func _ready():
	$Tutorial/RichTextLabel.hide()
	$BattleArena/RichTextLabel.hide()
	$End/RichTextLabel.hide()
	$Combat_Music.play()


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


# ERRORS
#- [x] if enemy has pizza piece, he cant steal more
#- [] make small cooldown for lightattack so it cant be spammed


# BACKLOG
#- [] 
