extends Area3D

var speed = 20.0  # Speed of the laser

func _ready():
	# Connect the signal to detect when the laser overlaps with another body
	connect("body_entered", _on_body_entered)

func _process(delta):
	# Move the laser forward
	position += transform.basis.z * speed * delta

	# Optional: Destroy the laser after traveling a large distance
	if position.length() > 1000:
		queue_free()

# This function is called when the laser overlaps with another body
func _on_body_entered(body):
	# Check if the object is a StaticBody3D
	if body is StaticBody3D:
		# Destroy the laser when it hits a StaticBody3D
		queue_free()
