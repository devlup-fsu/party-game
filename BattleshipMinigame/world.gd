extends Node3D

@export var players: Array[BSMPlayer]

var player_places: Array[Scores.Place] = [0, 0, 0, 0]
var current_place: Scores.Place = Scores.Place.FOURTH

func _ready():
	for player in players:
		player.died.connect(_on_player_died)


func _on_player_died(player: Controls.Player):
	player_places[player] = current_place
	current_place -= 1
	
	if current_place == Scores.Place.FIRST:
		SceneManager.exit_minigame(player_places[0], player_places[1], player_places[2], player_places[3])
