extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	rotation.z = deg_to_rad(randi_range(-45, 45))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.z += delta * 2
	$Cube.rotate_y(delta * 3)
	
	if (global_position.z > 5):
		position.y += delta * 50
	
	if (position.y > 50):
		queue_free()
		
	
	
	
