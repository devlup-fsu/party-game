extends Node3D

@onready var countdown_label: Label = %CountdownLabel
@onready var countdown_timer: Timer = %CountdownTimer


func _process(_delta: float) -> void:
	var time_left = int(countdown_timer.time_left)
	var min_left = time_left / 60
	var sec_left = time_left % 60
	countdown_label.text = "%d:%02d" % [min_left, sec_left]


func _on_countdown_timer_timeout() -> void:
	# Places have to be calculated by some measurement of the game.
	# E.g., order died, points collected, etc.
	SceneManager.exit_minigame(Scores.Place.FIRST, Scores.Place.SECOND, Scores.Place.THIRD, Scores.Place.FOURTH)
