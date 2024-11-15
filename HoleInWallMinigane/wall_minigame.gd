extends Node3D
@onready var _p1 := $Wall_Player3
@onready var _p2 := $Wall_Player4
@onready var _line: Path3D = $Path3D
@onready var scoreLabel: Label = $HBoxContainer/SubViewportContainer2/Score
var score = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scoreLabel.text = str(score)
	for i in range(_line.curve.point_count):
		print(_line.curve.get_point_position(i))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_line.curve.set_point_position(0, _p1.position)
	_line.curve.set_point_position(1, _p2.position)



func _on_area_3d_body_entered(body):
	print("Collision Occured!")


func _on_area_3d_area_entered(area):
	print("Area collision occured!")
	score = score - 1
	scoreLabel.text = str(score) 
