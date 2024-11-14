extends Node2D


@onready var players_list: Array = %Players.get_children()
@onready var timer_label: Label = $"../Timer/TimerLabel"


var labels = []
var timePos # location of timer
var totalTime: int = 10 # total time in seconds
var minute: int 
var sec: int


func _ready() -> void:
	for i in range(len(players_list)):
		var label = Label.new()
		label.text = "  Player %d:" % (i+1)
		label.position = Vector2(0, 20*i+40)
		labels.append(label)
		add_child(label)
		timePos = (i+1)*20+40
	timer_label.position = Vector2(0, timePos) # to keep in line with everything else


func _process(_delta: float) -> void:
	for i in range(len(labels)):
		labels[i].text = "  Player %d: %d" % [i+1, players_list[i].points]
	# $"../Timer/TimerLabel".text = "Time: %d:%d" % [min, sec]
	


func _on_timer_timeout() -> void: # connects to Timer node (1s) signals when hit 0
	if totalTime > 0:
		minute = totalTime/60
		sec = totalTime%60
		if sec <10: # for formatting
			$"../Timer/TimerLabel".text = "Time: %d:0%d" % [minute, sec]
		else:
			$"../Timer/TimerLabel".text = "Time: %d:%d" % [minute, sec]
		totalTime -= 1
	else:
		get_tree().change_scene_to_file("res://FactoryGame/end card/endAnimation.tscn") # swaps to end card scene
		
