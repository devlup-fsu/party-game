extends Area3D

const FALLING_SPEED = 3

var player_collided : GrabPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector3(0, 1, 0)  # Moving along the X-axis
	
	# Move the Area3D node
	position += direction * FALLING_SPEED * -1* delta
# x = rand
#z = rand if x^2 + z^2 < radius ^2 set spawn point at x , z
