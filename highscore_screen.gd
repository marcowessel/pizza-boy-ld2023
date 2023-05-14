extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$HighscoreLabel.text = str(Score.score)

func load_leaderboard_screen():
	get_tree().change_scene_to_file("res://addons/silent_wolf/Scores/Leaderboard.tscn")

func _on_button_pressed():
	var name = $LineEdit.text
	Score.set_player_name(name)
	SilentWolf.Scores.save_score(Score.player_name, Score.score)
	SilentWolf.Scores.get_scores()
	await get_tree().create_timer(0.1).timeout
	load_leaderboard_screen()
