extends Label

var is_showing = false
var is_hiding = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.text = str(Score.combo, "x")
	if Score.combo > 1:
		if !is_showing:
			is_hiding = false
			is_showing = true
			self.show()
			$Combo_Sound.play()
	else:
		if !is_hiding:
			is_hiding = true
			is_showing = false
			self.hide()
