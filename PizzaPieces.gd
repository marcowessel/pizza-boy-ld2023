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

func _physics_process(_delta):
	if(Input.is_physical_key_pressed(KEY_LEFT)):
		remove_piece()
		
	if(Input.is_physical_key_pressed(KEY_RIGHT)):
		add_piece()
