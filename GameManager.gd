extends Node2D

func _ready():
	$Tutorial/RichTextLabel.hide()
	$BattleArena/RichTextLabel.hide()
	$End/RichTextLabel.hide()
	$Combat_Music.play()

# TODO
#- [x] crosshair instead of cursor
#- [x] implement light attack
#- [x] baricade left / right activate
#- [] "WATCH OUT! PIZZA HOOLIGANS INCOMING" text appears few seconds
#- [] spawning of mobs, basic "zombies"
#- [] 20 mobs overall split into 3 waves
#- [] if all mobs are cleared baricades vanishes
#- [] activate camera follow again (smooth transition on player)
#- [] move delivery bag to that point smoothly (tween)
#- [] make small cooldown for lightattack so it cant be spammed
#- [] if enemy has pizza piece, he cant steal more
