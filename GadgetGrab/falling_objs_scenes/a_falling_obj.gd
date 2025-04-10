class_name AFallingObj
extends Area3D

@export var falling_obj_res: FallingObjRes

const FALLING_SPEED : float = -1.2

var rng = RandomNumberGenerator.new()
var x_rot_velo : float # rad/s
var y_rot_velo : float # rad/s
var z_rot_velo : float # rad/s

func _ready():
	add_child(falling_obj_res.objModel.instantiate())
	$CollisionShape3D.shape.size = Vector3.ONE * falling_obj_res.collision_size
	
	#rng.randomize()
	#x_rot_velo = rng.randf_range(3.14 * -2, 3.14 * 2)
	#y_rot_velo = rng.randf_range(3.14 * -2, 3.14 * 2)
	#z_rot_velo = rng.randf_range(3.14 * -2, 3.14 * 2)
	
	x_rot_velo = rng.randfn(0, 3.14 * 0.5)
	y_rot_velo = rng.randfn(0, 3.14 * 0.5)
	z_rot_velo = rng.randfn(0, 3.14 * 0.5)

func _physics_process(delta: float) -> void:
	position.y += FALLING_SPEED * delta
	rotation.x += x_rot_velo * delta
	rotation.y += y_rot_velo * delta
	rotation.z += z_rot_velo * delta
	
	
func _on_body_entered(body: Node3D) -> void:
	if body is GrabPlayer:
		body.objs_collected += 1
		queue_free()
	elif body is not AFallingObj:
		await get_tree().create_timer(2).timeout
		queue_free()
	
	
	
	
