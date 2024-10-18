class_name Wall_Player
extends CharacterBody3D

const FRICTION = 20
const SPEED = 8
const JUMP_VELOCITY = 4.5

var maxSpeed = 9


@export var player: Controls.Player
@export var color: Color
@export var chained_player: Wall_Player

func _ready() -> void:
	var material = $MeshInstance3D.get_surface_override_material(0)
	if material is StandardMaterial3D:
		material.albedo_color = color


func _physics_process(delta):
	if player == Controls.Player.ONE:
		if Input.is_action_pressed("wall_p1_up") and velocity.y < maxSpeed:
			if (velocity.y < 0):
				velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
			else:
				velocity.y += SPEED*delta
		elif Input.is_action_pressed("wall_p1_down") and velocity.y > -maxSpeed:
			if (velocity.y > 0):
				velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
			else:
				velocity.y += -SPEED*delta
		else:
			velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
		
	if player == Controls.Player.TWO:
		if Input.is_action_pressed("wall_p2_up"):
			if (velocity.y < 0):
				velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
			else:
				velocity.y += SPEED*delta
		elif Input.is_action_pressed("wall_p2_down"):
			if (velocity.y > 0):
				velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
			else:
				velocity.y += -SPEED*delta
		else:
			velocity.y = move_toward(velocity.y, 0.0, FRICTION * delta)
	
			
	var input_dir = Controls.get_vector(player, "core_player_left", "core_player_right", "core_player_up", "core_player_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
