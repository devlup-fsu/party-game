extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.z += delta * 2
	rotation.y += delta *3
	
	if (position.z > 7.5):
		position.y += delta * 50
	
	if (position.y > 50):
		queue_free()
		
	
	
	
