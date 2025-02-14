class_name GrabPlayer
extends CharacterBody3D

#const SPEED = 5.0
const JUMP_VELOCITY = 2.0 # m/s
const GRAVITY = -1.6 #m/s^2
const MAX_LINEAR_SPEED = 10.0 #m/s
const LINEAR_ACCELERATION = 20.0 # m/s^2
const CROSS_PROD_DEADZONE = 0.01 #unitless
const INPUT_VECTOR_DEADZONE = 0.2 #unitless


var target_lin_velo : float = 0.0 # m/s
var lin_velo : float = 0.0 # m/s

@export var player: Controls.Player
@export var color : Color

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += Vector3(0,GRAVITY,0) * delta
	
	if Controls.is_action_just_pressed(player, "core_player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var input_direction : Vector2 = Controls.get_vector(player, "core_player_left", "core_player_right", "core_player_up" , "core_player_down")
	var forward_direction: Vector2 = Vector2(-transform.basis.z.normalized().x, -transform.basis.z.normalized().z)
	
	if input_direction.length() > INPUT_VECTOR_DEADZONE:
		rotation.y = atan2(input_direction[1], input_direction[0])
	
	set_target_lin_velo(input_direction)
	
	lin_velo = move_toward(lin_velo, target_lin_velo, delta * LINEAR_ACCELERATION)
	
	velocity.x = forward_direction.y * lin_velo
	velocity.z = forward_direction.x * lin_velo 
	
	
	move_and_slide()


func set_target_lin_velo(input_vector: Vector2):
	if(input_vector.length() > INPUT_VECTOR_DEADZONE):
		target_lin_velo = input_vector.length() * MAX_LINEAR_SPEED
	else:
		target_lin_velo = 0
