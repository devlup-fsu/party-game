extends Node3D
@onready var _p1 := $WorldEnvironment/Wall_Player
@onready var _p2 := $WorldEnvironment/Wall_Player2
@onready var _line: Path3D = $Path3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
