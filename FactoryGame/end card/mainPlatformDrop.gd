# extends AnimatableBody3D
#TODO NOT CURRENTLY IN USE
extends StaticBody3D
var yPos : float
var yVec : float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#yPos.move_toward(-1, delta * 5)
	#yVec = move_toward(yPos,-1,delta*5)
	#translate(Vector3(0,yVec,0))
	pass
