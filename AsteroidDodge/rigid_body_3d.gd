extends RigidBody3D

var speed = 100
var target_velocity = Vector3.ZERO
var velocity = linear_velocity
func _physics_process(delta):
	velocity.x = 1
	velocity.z = 1
	apply_force(velocity)
	
