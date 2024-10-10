extends CharacterBody3D


const MAX_LIN_SPEED = 20.0 # m/sec
const LIN_ACCEL = 20.0 # m/sec^2
const MAX_ROTATIONAL_VELO = 5.0 # rads/sec
const ROTATIONAL_ACCEL = 15.0 # rads/sec^2
const TARGET_CENTRIP_ACCEL = 75.0 # m/sec^2


var target_lin_velo : float = 0.0 # m/sec
var lin_velo : float = 0.0 # m/sec
var target_rotational_velo : float = 0.0 # rads/sec
var rotational_velo : float = 0.0 # rads/sec

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	set_target_rotational_velo()
	set_target_lin_velo()
	
	# Handle rotational/linear velocity
	rotational_velo = move_toward(rotational_velo, target_rotational_velo, ROTATIONAL_ACCEL * delta)
	lin_velo = move_toward(lin_velo, target_lin_velo, LIN_ACCEL * delta)
	
	# Apply rotational velocity
	rotation.y += rotational_velo * delta
	
	print(str(rotational_velo))
	# Based on forward direction vector, set directional velocity
	var forward_direction = -transform.basis.z.normalized()
	velocity.x = forward_direction.x * lin_velo
	velocity.z = forward_direction.z * lin_velo

	move_and_slide()

func set_target_rotational_velo():
	if (Input.is_action_pressed("p1_turn_left") == Input.is_action_pressed("p1_turn_right")):
		target_rotational_velo = 0.0
	elif lin_velo <= 15:
		if (Input.is_action_pressed("p1_turn_left")):	
			target_rotational_velo = MAX_ROTATIONAL_VELO
		else:
			target_rotational_velo = -1 * MAX_ROTATIONAL_VELO
	else:
		if (Input.is_action_pressed("p1_turn_left")):	
			target_rotational_velo = TARGET_CENTRIP_ACCEL / lin_velo
		else:
			target_rotational_velo = -1 * TARGET_CENTRIP_ACCEL / lin_velo

func set_target_lin_velo():
	if (Input.is_action_pressed("p1_forward")):
		target_lin_velo = MAX_LIN_SPEED
	else:
		target_lin_velo = 0.0
