extends AudioStreamPlayer
class_name RandomRangePlayer

@export var streams : Array[Resource] = []
var last_stream_id = -1

func rplay():
	if len(streams) == 0:
		return
	var ran = randi() % len(streams)
	if ran == last_stream_id:
		ran = (ran + 1) % len(streams)
	last_stream_id = ran
	stream = streams[ran]
	play()
