extends Node2D

var labels = []
var timePos # location of timer
var totalTime: int = 2 * 60 # total time in seconds
var min: int 
var sec: int


func _ready() -> void:
	for i in range(len($"../Players".get_children())):
		var label = Label.new()
		label.text = "  Player %d:" % (i+1)
		label.position = Vector2(0, 20*i+40)
		labels.append(label)
		add_child(label)
		timePos = (i+1)*20+40
	$"../Timer/TimerLabel".position = Vector2(0, timePos) # to keep in line with everything else


func _process(_delta: float) -> void:
	var players = $"../Players".get_children()
	for i in range(len(labels)):
		labels[i].text = "  Player %d: %d" % [i+1, players[i].points]
	# $"../Timer/TimerLabel".text = "Time: %d:%d" % [min, sec]
	


func _on_timer_timeout() -> void: # connects to Timer node (1s) signals when hit 0
	if totalTime > 0:
		min = totalTime/60
		sec = totalTime%60
		if sec <10: # for formatting
			$"../Timer/TimerLabel".text = "Time: %d:0%d" % [min, sec]
		else:
			$"../Timer/TimerLabel".text = "Time: %d:%d" % [min, sec]
		totalTime -= 1
	else:
		get_tree().change_scene_to_file("res://FactoryGame/EndCard/EndCard.tscn") # swaps to end card scene
		
