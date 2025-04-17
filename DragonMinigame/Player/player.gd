class_name DragonGamePlayer
extends CharacterBody3D

@export var player_number: Controls.Player

@onready var origin_position = position

enum LaneLocation {
	LEFT,
	MIDDLE,
	RIGHT
}

const GRAVITY = -0.75
const STOMP_GRAVITY = -1.5
const JUMP_DURATION = 0.5

var is_jumping = false
var can_jump = false
var jump_hold_timer = 0.0
var prev_jump_button_state = false;

var is_ducking = false

var lane_location = LaneLocation.MIDDLE

var elimination_time: float = -1.0

## Eliminate this player.
func eliminate():
	if elimination_time == -1.0:
		elimination_time = $"../..".cumulative_time
		visible = false
	
	
func jump_tick(delta: float):
	if is_on_floor():
		if lane_location == LaneLocation.MIDDLE:
			jump_hold_timer = 0.0
			can_jump = true
		else:
			can_jump = false
	
	var axis = Controls.get_axis(player_number, 'core_player_down', 'core_player_up')
	var jump_button_state = axis < -0.5 or Controls.is_action_pressed(player_number, 'core_player_jump')
	if jump_button_state and can_jump and jump_hold_timer < JUMP_DURATION:
		velocity.y = remap(jump_hold_timer, 0, JUMP_DURATION, 8, 0)
		jump_hold_timer = move_toward(jump_hold_timer, JUMP_DURATION, delta)
		is_jumping = true
	
	if (jump_hold_timer >= JUMP_DURATION) or \
		not jump_button_state and prev_jump_button_state and is_jumping:  # Released button while jumping
		is_jumping = false
		can_jump = false
	
	prev_jump_button_state = jump_button_state
	

func duck_tick(_delta: float):
	var axis = Controls.get_axis(player_number, 'core_player_down', 'core_player_up')
	is_ducking = axis > 0.5
	if is_ducking:
		$CollisionShape.disabled = true
		$DuckingCollisionShape.disabled = false
		$Mesh.visible = false
		$DuckingMesh.visible = true
	else:
		$CollisionShape.disabled = false
		$DuckingCollisionShape.disabled = true
		$Mesh.visible = true
		$DuckingMesh.visible = false


func lane_change_tick(_delta: float):
	if is_on_floor():
		var axis = Controls.get_axis(player_number, 'core_player_left', 'core_player_right')
		var west = axis < -0.5
		var east = axis > 0.5
		if west and east:  # Pressing both buttons fsr
			lane_location = LaneLocation.MIDDLE
		elif west:
			lane_location = LaneLocation.LEFT
		elif east:
			lane_location = LaneLocation.RIGHT
		else:  # Not pressing either button
			lane_location = LaneLocation.MIDDLE
	
		if lane_location == LaneLocation.LEFT:
			position = origin_position + Vector3.LEFT
		elif lane_location == LaneLocation.MIDDLE:
			position = origin_position
		else:
			position = origin_position + Vector3.RIGHT


func _physics_process(delta: float) -> void:
	if elimination_time != -1.0:
		return
	
	if not is_jumping:
		if is_ducking:
			velocity.y += STOMP_GRAVITY
		else:
			velocity.y += GRAVITY
	
	lane_change_tick(delta)
	jump_tick(delta)
	duck_tick(delta)
	move_and_slide()
