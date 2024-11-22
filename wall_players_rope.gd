extends Node3D

signal astroid_hit

@export var left_player: Controls.Player
@export var right_player: Controls.Player

@onready var _p1 := $Wall_Player1
@onready var _p2 := $Wall_Player2
@onready var _line: Path3D = $Path3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_p1.player = left_player
	_p2.player = right_player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_line.curve.set_point_position(0, _p1.position)
	_line.curve.set_point_position(1, _p2.position)


func _on_area_3d_area_entered(area: Area3D) -> void:
	astroid_hit.emit()
