extends Area3D

const FALLING_SPEED = 10

var player_collided : GrabPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
# x = rand
#z = rand if x^2 + z^2 < radius ^2 set spawn point at x , z
