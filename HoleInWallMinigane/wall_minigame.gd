extends Node3D

@onready var scoreLabel1: Label = $HBoxContainer/SubViewportContainer2/Score
@onready var scoreLabel2: Label = $HBoxContainer/SubViewportContainer/Score
var score1 = 0
var score2 = 0
var HitTimer = 2
var HitTimer2 = 2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreLabel1.text = str(score1)
	scoreLabel2.text = str(score2)
	#@for i in range(_line.curve.point_count):
		#print(_line.curve.get_point_position(i))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	HitTimer = HitTimer - delta
	HitTimer2 = HitTimer2 - delta




func _on_wall_players_rope_astroid_hit() -> void:
	if HitTimer < 0:
		score1 = score1 + 1
		HitTimer = 2
	scoreLabel1.text = str(score1) 


func _on_wall_players_rope_2_astroid_hit() -> void:
	if HitTimer2 < 0:
		score2 = score2 + 1
		HitTimer2 = 2
	scoreLabel2.text = str(score2) 
