extends CharacterBody3D


const MAX_LIN_SPEED = 20.0 # m/sec
const LIN_ACCEL = 40.0 # m/sec^2
const MAX_ROTATIONAL_VELO = 5.0 # rads/sec
const ROTATIONAL_ACCEL = 15.0 # rads/sec^2
const TARGET_CENTRIP_ACCEL = 75.0 # m/sec^2
const CROSS_PROD_DEADZONE = 0.0001 # unitless

var target_lin_velo : float = 0.0 # m/sec
var lin_velo : float = 0.0 # m/sec
var target_rotational_velo : float = 0.0 # rads/sec
var rotational_velo : float = 0.0 # rads/sec


@export var player: Controls.Player
@export var color: Color


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir : Vector2 = Controls.get_vector(player, "core_player_left", "core_player_right", "core_player_up", "core_player_down")
	var forward_dir = Vector2(-transform.basis.z.normalized().x, -transform.basis.z.normalized().z)
	set_target_rotational_velo(input_dir, forward_dir)
	set_target_lin_velo(input_dir)
	
	# Handle rotational/linear velocity
	rotational_velo = move_toward(rotational_velo, target_rotational_velo, ROTATIONAL_ACCEL * delta)
	lin_velo = move_toward(lin_velo, target_lin_velo, LIN_ACCEL * delta)
	
	# Apply rotational velocity
	rotation.y += rotational_velo * delta
	
	print(str(rotational_velo))
	# Based on forward direction vector, set directional velocity
	
	velocity.x = forward_dir.x * lin_velo
	velocity.z = forward_dir.y * lin_velo # forward_dir is a Vector2, so grab the y


	move_and_slide()

func set_target_rotational_velo(input_vector: Vector2, forward_vector: Vector2):
	var cross_prod : float = input_vector.cross(forward_vector)
	if (input_vector.length() == 0) or ((abs(cross_prod) < CROSS_PROD_DEADZONE) and (input_vector.dot(forward_vector) > 0)):
		target_rotational_velo = 0
		return

	if (cross_prod > 0):
		target_rotational_velo = MAX_ROTATIONAL_VELO * sqrt(cross_prod)
	else:
		target_rotational_velo = -1 * MAX_ROTATIONAL_VELO * sqrt(abs(cross_prod))

func set_target_lin_velo(input_vector: Vector2):
	target_lin_velo = input_vector.normalized().length() * MAX_LIN_SPEED
