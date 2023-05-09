extends Label

var is_showing = false
var is_hiding = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = str(Score.combo, "x")
	if Score.combo > 0:
		if !is_showing:
			is_hiding = false
			is_showing = true
			self.show()
	else:
		if !is_hiding:
			is_hiding = true
			is_showing = false
			self.hide()
