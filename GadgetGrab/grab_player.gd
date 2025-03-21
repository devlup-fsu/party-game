class_name GrabPlayer
extends CharacterBody3D

const GRAVITY_ACCEL = -5 # m/s^2
const JUMP_VELO = 4 # m/s
const MAX_LIN_SPEED = 10.0 # m/s
const LIN_ACCEL = 20.0 # m/s^2
const MAX_ROTATIONAL_VELO = 10.0 # rads/s
const ROTATIONAL_ACCEL = 30.0 # rads/s^2
const TARGET_CENTRIP_ACCEL = 75.0 # m/s^2
const CROSS_PROD_DEADZONE = 0.05 # unitless
const INPUT_VECTOR_DEADZONE = 0.2 # unitless

var target_lin_velo : float = 0.0 # m/s
var lin_velo : float = 0.0 # m/s
var target_rotational_velo : float = 0.0 # rads/s
var rotational_velo : float = 0.0 # rads/s

var objs_collected : int = 0 # how many  
var cycle_num : int = 0 # used for debug printing




@export var player: Controls.Player

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# ! Physics Processing
	
	if not is_on_floor():
		velocity += Vector3(0,GRAVITY_ACCEL,0) * delta
	
	if Controls.is_action_just_pressed(player, "core_player_jump") and is_on_floor():
		
		$GadgetGrabber/AnimationPlayer.play("Cube_009Action", 0, .52)
		$GadgetGrabber/AnimationPlayer.play("Cube_010Action",1)
		await get_tree().create_timer(.05).timeout
		velocity.y = JUMP_VELO
		

	
	var input_dir : Vector2 = Controls.get_vector(player, "core_player_left", "core_player_right", "core_player_up", "core_player_down")
	var forward_dir : Vector2 = Vector2(-transform.basis.z.normalized().x, -transform.basis.z.normalized().z)
	
	if (input_dir.length() > 1.0):
		input_dir = input_dir.normalized()
	
	set_target_rotational_velo(input_dir, forward_dir)
	set_target_lin_velo(input_dir)
	
	# Handle rotational/linear velocity
	if abs(input_dir.cross(forward_dir)) < CROSS_PROD_DEADZONE and input_dir.dot(forward_dir) > 0:
		rotational_velo *= 0.1
	elif is_on_floor():
		rotational_velo = move_toward(rotational_velo, target_rotational_velo, ROTATIONAL_ACCEL * delta)
	else:
		rotational_velo = move_toward(rotational_velo, target_rotational_velo, ROTATIONAL_ACCEL * delta * 0.3)
	lin_velo = move_toward(lin_velo, target_lin_velo, LIN_ACCEL * delta)


	
	#if (cycle_num % 10 == 0) and (input_dir.length() > 0.1):
		#print("Target lin velo: " + str(target_lin_velo) +
			  #"\nCurrent input vector" + str(input_dir) +
			  #"\nInput vector length: " + str(input_dir.length()) +
			  #"\nCalced target velo: " + str(input_dir.length() * MAX_LIN_SPEED) +
			  #"\nCurrent rotational velo: " + str(rotational_velo) +
			  #"\nCurrent tilt: " + str(rotation.z) +
			  #"\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	
	rotation.y += rotational_velo * delta
	velocity.x = forward_dir.x * lin_velo
	velocity.z = forward_dir.y * lin_velo # forward_dir is a Vector2, so grab the y

	# print(str(position.y))
	if(not is_on_floor()):
		velocity.x = velocity.x * 0.7
		velocity.z = velocity.z * 0.7
		
	cycle_num += 1
	move_and_slide()
	


func set_target_rotational_velo(input_vector: Vector2, forward_vector: Vector2):
	var cross_prod : float = input_vector.cross(forward_vector)
	if (input_vector.length() < INPUT_VECTOR_DEADZONE) and ((abs(cross_prod) < CROSS_PROD_DEADZONE) and (input_vector.dot(forward_vector) > 0)):
		target_rotational_velo = 0
		return
	if (cross_prod > 0):
		target_rotational_velo = MAX_ROTATIONAL_VELO * sqrt(cross_prod)
	else:
		target_rotational_velo = -1 * MAX_ROTATIONAL_VELO * sqrt(abs(cross_prod))

func set_target_lin_velo(input_vector: Vector2):
	if (input_vector.length() > INPUT_VECTOR_DEADZONE):
		target_lin_velo = input_vector.length() * MAX_LIN_SPEED
	else:
		target_lin_velo = 0
