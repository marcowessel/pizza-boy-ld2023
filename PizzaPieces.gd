extends Sprite2D

func remove_piece():
	if(self.frame == 8):
		print("keine pizza stücke mehr")
	else:
		self.frame += 1
	
func add_piece():
	if(self.frame == 0):
		print("volle pizza!")
	else:
		self.frame -= 1
