extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(Vector3(0,move_toward(0,1,delta*5),0)) # Infintely move up
	rotate(Vector3(0,1,0), delta*1)
	#pass
