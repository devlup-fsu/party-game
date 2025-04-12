extends Node3D


@onready var players_list: Array = %Players.get_children()

const GAME_DURATION = 90.0  # Seconds

var seconds_remaining: int = GAME_DURATION


func _ready() -> void:
	_on_timer_timeout()  # Initialize timer label
	randomize()


func _physics_process(delta: float) -> void:
	%Score1.text = str(players_list[0].points)
	%Score2.text = str(players_list[1].points)
	%Score3.text = str(players_list[2].points)
	%Score4.text = str(players_list[3].points)


func get_player_rankings(scores: Array[float], lower_is_better: bool=false) -> Array[Scores.Place]:
	var unique_scores: Array[float] = []
	for score in scores:
		if not score in unique_scores:
			unique_scores.append(score)
	
	unique_scores.sort()
	if lower_is_better:
		unique_scores.reverse()
	
	var score_to_place: Dictionary[float, Scores.Place] = {}
	for place in range(unique_scores.size()):
		score_to_place[unique_scores[place]] = place
	
	var placements: Array[Scores.Place] = []
	for score in scores:
		placements.append(score_to_place[score])
	
	return placements


func _on_timer_timeout() -> void:
	if seconds_remaining > 0:
		var minute = seconds_remaining / 60
		var seconds = seconds_remaining % 60
		if seconds < 10:
			%TimerLabel.text = "%d:0%d" % [minute, seconds]
		else:
			%TimerLabel.text = "%d:%d" % [minute, seconds]
		seconds_remaining -= 1
	else:
		var scores: Array[float] = []
		for player: FactoryPlayer in players_list:
			scores.append(float(player.points))
		var placements = get_player_rankings(scores)
		SceneManager.exit_minigame(placements[0], placements[1], placements[2], placements[3])
