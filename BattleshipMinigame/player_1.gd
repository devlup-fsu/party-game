class_name BSMPlayer
extends CharacterBody3D


const MAX_LIN_SPEED = 20.0 # m/sec
const LIN_ACCEL = 40.0 # m/sec^2
const MAX_ROTATIONAL_VELO = 5.0 # rads/sec
const ROTATIONAL_ACCEL = 30.0 # rads/sec^2
const TARGET_CENTRIP_ACCEL = 75.0 # m/sec^2
const CROSS_PROD_DEADZONE = 0.01 # unitless
const INPUT_VECTOR_DEADZONE = 0.2 # unitless
const LASER_COOLDOWN_TIME = 0.25 # sec
const MAX_TILT = 3.14 / 6 # rads
const TILT_ACCEL = 3.14 / 3 # rads/sec^2

var target_lin_velo : float = 0.0 # m/sec
var lin_velo : float = 0.0 # m/sec
var target_rotational_velo : float = 0.0 # rads/sec
var rotational_velo : float = 0.0 # rads/sec
var cycle_num : int = 0 # used for debug printing
var time_since_last_laser : float = 0.0 # cooldown for shooting laser
var lives_remaining : int = 3


@export var player: Controls.Player
@export var color: Color
@export var laser_scene : PackedScene

func _ready() -> void:
	var tip_material = $Tip.get_surface_override_material(0)
	if tip_material is StandardMaterial3D:
		tip_material.albedo_color = color

func _physics_process(delta: float) -> void:
	# ! Physics Processing
	
	var input_dir : Vector2 = Controls.get_vector(player, "core_player_left", "core_player_right", "core_player_up", "core_player_down")
	var forward_dir : Vector2 = Vector2(-transform.basis.z.normalized().x, -transform.basis.z.normalized().z)
	set_target_rotational_velo(input_dir, forward_dir)
	set_target_lin_velo(input_dir)
	
	# Handle rotational/linear velocity
	rotational_velo = move_toward(rotational_velo, target_rotational_velo, ROTATIONAL_ACCEL * delta)
	lin_velo = move_toward(lin_velo, target_lin_velo, LIN_ACCEL * delta)
	
	# Apply rotational velocity
	rotation.y += rotational_velo * delta
	
	# Apply tilt
	# rotation.z = move_toward((rotational_velo / MAX_ROTATIONAL_VELO) * MAX_TILT, rotation.z, TILT_ACCEL * delta)
	rotation.z = (rotational_velo / MAX_ROTATIONAL_VELO) * MAX_TILT
	
	if (cycle_num % 10 == 0) and (input_dir.length() > 0.1):
		print("Target lin velo: " + str(target_lin_velo) +
			  "\nCurrent input vector" + str(input_dir) +
			  "\nInput vector length: " + str(input_dir.length()) +
			  "\nCalced target velo: " + str(input_dir.length() * MAX_LIN_SPEED) +
			  "\nCurrent rotational velo: " + str(rotational_velo) +
			  "\nCurrent tilt: " + str(rotation.z) +
			  "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	# Based on forward direction vector, set directional velocity
	
	velocity.x = forward_dir.x * lin_velo
	velocity.z = forward_dir.y * lin_velo # forward_dir is a Vector2, so grab the y

	# print(str(position.y))

	cycle_num += 1
	move_and_slide()
	
	
	# ! Laser Spawning
	time_since_last_laser += delta
	
	if (Controls.is_action_just_pressed(player, "core_player_jump")) and (time_since_last_laser > LASER_COOLDOWN_TIME):
		shoot_laser()
		time_since_last_laser = 0
	
	
	# ! Lives Handling
	if (lives_remaining == 0):
		queue_free()

func set_target_rotational_velo(input_vector: Vector2, forward_vector: Vector2):
	var cross_prod : float = input_vector.cross(forward_vector)
	if (input_vector.length() < INPUT_VECTOR_DEADZONE) or ((abs(cross_prod) < CROSS_PROD_DEADZONE) and (input_vector.dot(forward_vector) > 0)):
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
		
func shoot_laser():
	var laser_spawn_point = $LaserStartPosition  # Get the marker position for laser spawning
	var laser = laser_scene.instantiate() as Area3D # Instance the laser
	
	get_parent().add_child(laser) # Add laser to the scene
	
	# Set the laser's position at the marker position
	laser.global_transform.origin = laser_spawn_point.global_transform.origin
	laser.rotation = self.rotation
	laser.shooter = self

	# Set the laser's direction (same as the forward direction of the spaceship)
	laser.set_direction(-transform.basis.z.normalized())
