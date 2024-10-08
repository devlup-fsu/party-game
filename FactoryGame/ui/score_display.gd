extends Node2D

var labels = []

func _ready() -> void:
	for i in range(len($"../Players".get_children())):
		var label = Label.new()
		label.text = "  Player %d:" % (i+1)
		label.position = Vector2(0, 20*i+40)
		labels.append(label)
		add_child(label)


func _process(_delta: float) -> void:
	var players = $"../Players".get_children()
	for i in range(len(labels)):
		labels[i].text = "  Player %d: %d" % [i+1, players[i].points]
