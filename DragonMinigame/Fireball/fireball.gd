extends Area3D
class_name DragonGameFireball

const self_scene = preload("res://DragonMinigame/Fireball/fireball.tscn")

const DESTROY_POSITION_Z = 7.5

const TRAVEL_TIME = 1.25

var speed = 0.0


static func create() -> DragonGameFireball:
	var fireball = self_scene.instantiate()
	return fireball


func _physics_process(delta: float) -> void:
	global_position += Vector3.BACK * speed * delta
	if global_position.z > DESTROY_POSITION_Z:
		queue_free()
		

func _on_body_entered(body: Node3D) -> void:
	if body is DragonGamePlayer:
		body.eliminate()
