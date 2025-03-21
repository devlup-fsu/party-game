class_name AFallingObj
extends Area3D

@export var falling_obj_res: FallingObjRes

const FALLING_SPEED : float = 0.2

func _ready():
	add_child(falling_obj_res.objModel.instantiate())
	$CollisionShape3D.shape.size = Vector3.ONE * falling_obj_res.collision_size

func _physics_process(delta: float) -> void:
	position.y += FALLING_SPEED
	
func _on_body_entered(body: Node3D) -> void:
	if body is GrabPlayer:
		body.objs_collected += 1
		queue_free()
	elif body is not AFallingObj:
		queue_free()
	
	
	
	
