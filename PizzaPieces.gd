extends Sprite2D

var pizza_count = 0
@export var pizza_pieces = 8

func remove_piece(pizza_loss):
	if(self.frame == 8):
		print("keine pizza stücke mehr")
	else:
		self.frame += pizza_loss
		pizza_pieces -= pizza_loss
		print(pizza_pieces)
	
func add_piece():
	if(self.frame == 0):
		print("volle pizza!")
	else:
		self.frame -= 1
		pizza_pieces += 1
		print(pizza_pieces)

func calculate_score():
	for i in range(pizza_pieces):
		pizza_count += 1
		Score.score += 10000
		self.frame += 1
		get_parent().get_node("Pizza_Points").rplay()
		await get_tree().create_timer(1).timeout
	if pizza_count == 8:
		get_parent().get_node("Jackpot").play()
		Score.score *= 2
