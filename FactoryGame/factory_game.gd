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
		SceneManager.exit_minigame(0, 0, 0, 0)
