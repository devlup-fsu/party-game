extends Node3D

var score1 = 3
var score2 = 3
var HitTimer = 2
var HitTimer2 = 2
@export var lives1: Array[Node]
@export var lives2: Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#@for i in range(_line.curve.point_count):
		#print(_line.curve.get_point_position(i))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	
	HitTimer = HitTimer - delta
	HitTimer2 = HitTimer2 - delta
	


func _on_wall_players_rope_astroid_hit() -> void:
	if HitTimer < 0:
		score1 = score1 - 1
		lives1[score1].queue_free()
		HitTimer = 2


func _on_wall_players_rope_2_astroid_hit() -> void:
	if HitTimer2 < 0:
		score2 = score2 - 1
		lives2[score2].queue_free()
		HitTimer2 = 2
