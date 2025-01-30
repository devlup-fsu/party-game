extends CharacterBody3D
class_name FactoryPlayer

@export var player_number: Controls.Player

@onready var throw_strength_bar = $ThrowStrengthBar
@onready var player_mesh = $MeshInstance3D
@onready var carried_fuel_position = $CarriedFuelPosition


var stunned_material = preload("res://FactoryGame/Resources/Materials/temp_stunned_material.tres")

const PLAYER_COLORS = [
	Color('#FF0000'),
	Color('#0000FF'),
	Color('#FFFF00'),
	Color('#00FF00')
]

enum PunchState {
	IDLE,
	DANGER,
	COOLDOWN
}

const MAX_VELOCITY = 10.0
const ACCELERATION = 2.5
const FRICTION = 1.5
const STUNNED_FRICTION = 0.5  # Friction that is applied when stunned.
const JUMP_VELOCITY = 4.5
const JOYSTICK_CARDINAL_SNAP_ANGLE = 0.075
const JOYSTICK_SNAPBACK_ANGLE = 120  # Degrees

const PICKUP_COOLDOWN = 0.5
const THROW_CHARGE_TIME = 0.8
const THROW_STRENGTH_HORIZONTAL = 18.0
const THROW_STRENGTH_VERTICAL = 0.1
const THROW_STRENGTH_PLAYER_VELOCITY_INFLUENCE = 0.2
const THROW_STRENGTH_MINIMUM = 0.3

const THROW_BAR_SCALE = 1000
const THROW_BAR_SMOOTHING_SPEED: float = 0.35

const PUNCH_HITBOX_DISTANCE = 1.5
const PUNCH_DANGER_TIME = 0.3
const PUNCH_COOLDOWN_TIME = 0.75
const PUNCH_SPEED_MODIFIER = 0.3  # Slow down the player while they're punching
const PUNCH_FORCE = 10.0  # How far the player should be knocked back when punched

const STUN_DURATION = 0.75
const STUN_DROP_STRENGTH = 6.5

var previous_direction = Vector3(1, 0, 0)
var facing_direction = Vector3(1, 0, 0);
var prev_throwbutton_state = false;

var points = 0
var carried_fuel_node: Fuel = null
var current_pickup_cooldown = 0
var throw_charge = 0.0
var throw_charge_increasing = true;
var punch_state := PunchState.IDLE
var punch_timer = 0.0
var punch_direction: Vector3 = Vector3.ZERO
var is_stunned: bool = false
var stun_timer = 0.0

var player_material: StandardMaterial3D


func reset_player_material():
	player_mesh.set_surface_override_material(0, player_material)

func set_stunned_material():
	player_mesh.set_surface_override_material(0, stunned_material)


func _ready() -> void:
	player_material = StandardMaterial3D.new()
	player_material.albedo_color = PLAYER_COLORS[player_number]
	player_material.roughness = 0.2
	reset_player_material()
	
	# Setup throw strength bar
	throw_strength_bar.max_value = THROW_CHARGE_TIME * THROW_BAR_SCALE
	throw_strength_bar.visible = false
	throw_strength_bar.modulate = Color(1, 1, 1, 0.8)


func get_direction() -> Vector3:
	var input_dir: Vector2
	input_dir = Controls.get_vector(player_number, "core_player_left", "core_player_right", "core_player_up", "core_player_down")
	input_dir.x = 0.0 if abs(input_dir.x) < JOYSTICK_CARDINAL_SNAP_ANGLE else input_dir.x
	input_dir.y = 0.0 if abs(input_dir.y) < JOYSTICK_CARDINAL_SNAP_ANGLE else input_dir.y
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


func update_velocity(direction: Vector3):
	var friction = FRICTION if not is_stunned else STUNNED_FRICTION
	if direction.x:
		velocity.x = clamp(velocity.x + direction.x * ACCELERATION, -MAX_VELOCITY, MAX_VELOCITY)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)
	if direction.z:
		velocity.z = clamp(velocity.z + direction.z * ACCELERATION, -MAX_VELOCITY, MAX_VELOCITY)
	else:
		velocity.z = move_toward(velocity.z, 0, friction)
	
	if punch_state != PunchState.IDLE:
		velocity *= PUNCH_SPEED_MODIFIER


func reset_throw_charge():
	current_pickup_cooldown = PICKUP_COOLDOWN
	throw_charge = 0.0
	throw_strength_bar.visible = false
	throw_strength_bar.value = 0

func get_throw_strength():
	return ease(remap(throw_charge, 0.0, THROW_CHARGE_TIME, 0.0, 1.0), 2.0)

func throw_tick(delta: float):
	var current_throwbutton_state: bool
	current_throwbutton_state = Controls.is_action_pressed(player_number, 'core_player_jump')
	
	if carried_fuel_node != null:
		if current_throwbutton_state:  # Holding the throw button
			throw_charge = move_toward(throw_charge, THROW_CHARGE_TIME * int(throw_charge_increasing), delta)
			if throw_charge == THROW_CHARGE_TIME:
				throw_charge_increasing = false;
			elif throw_charge == 0:
				throw_charge_increasing = true;
			
			throw_strength_bar.visible = true
			throw_strength_bar.value = get_throw_strength() * THROW_BAR_SCALE
		
		elif prev_throwbutton_state:  # Released the throw button
			var throw_strength = get_throw_strength()
			var throw_direction = Vector3(facing_direction.x, THROW_STRENGTH_VERTICAL, facing_direction.z)
			carried_fuel_node.linear_velocity = throw_direction * throw_strength \
				* THROW_STRENGTH_HORIZONTAL \
				+ (velocity * THROW_STRENGTH_PLAYER_VELOCITY_INFLUENCE)
			var angular_vector = throw_direction.rotated(Vector3(0, 1, 0), PI/4) * throw_strength * 10
			carried_fuel_node.angular_velocity = angular_vector
			
			carried_fuel_node.is_dangerous = true  # Sets dangerous to true once the fuel cell is thrown
			carried_fuel_node.being_carried = false
			carried_fuel_node = null
			
			$SFX/Throw.pitch_scale = throw_strength + 1.0  # Increase pitch with throw charge
			$SFX/Throw.play()
			
			reset_throw_charge()
	
	prev_throwbutton_state = current_throwbutton_state


func get_strength_bar_target_position():
	var player_pos = global_transform.origin
	var screen_pos = %Camera.unproject_position(player_pos)
	var viewport_rect = get_viewport().get_visible_rect()
	var target_position = screen_pos + Vector2(10, -20)
	target_position.x = clamp(target_position.x, 0, viewport_rect.size.x)
	target_position.y = clamp(target_position.y, 0, viewport_rect.size.y)
	return target_position

func update_strength_bar_position():
	var target_position = get_strength_bar_target_position()
	throw_strength_bar.global_position = throw_strength_bar.global_position.lerp(
		target_position, THROW_BAR_SMOOTHING_SPEED
	)


# Stuns this player.
func stun(drop_vector: Vector3, push: bool):
	set_stunned_material()
	is_stunned = true
	stun_timer = STUN_DURATION
	
	drop_vector = drop_vector.normalized()
	
	# Push player back
	if push:
		var push_vector = drop_vector
		push_vector.y = 0.0
		velocity = push_vector * PUNCH_FORCE
	
	# Drop fuel
	if carried_fuel_node != null:
		carried_fuel_node.being_carried = false
		var angular_vector = drop_vector.rotated(Vector3(0, 1, 0), PI/4.0)
		carried_fuel_node.linear_velocity = drop_vector * STUN_DROP_STRENGTH
		carried_fuel_node.angular_velocity = angular_vector * STUN_DROP_STRENGTH
		carried_fuel_node = null
	
	# Play punch sound
	$SFX/Punch.play()

func stun_tick(delta: float):
	if is_stunned:
		stun_timer = move_toward(stun_timer, 0, delta) # reduces current stun duration by delta until 0
		if stun_timer <= 0:
			is_stunned = false
			reset_player_material()
	
	
func punch_tick(delta: float):
	$PunchHitbox.position = facing_direction * PUNCH_HITBOX_DISTANCE
	if Controls.is_action_pressed(player_number, 'core_player_east') \
	and punch_state == PunchState.IDLE \
	and not is_stunned \
	and carried_fuel_node == null:
		punch_state = PunchState.DANGER
		punch_timer = PUNCH_DANGER_TIME
		punch_direction = facing_direction
		$SFX/PunchSwing.play()
	
	if punch_state == PunchState.DANGER:
		punch_timer -= delta
		if punch_timer <= 0:
			punch_state = PunchState.COOLDOWN
			punch_timer = PUNCH_COOLDOWN_TIME
	elif punch_state == PunchState.COOLDOWN:
		punch_timer -= delta
		if punch_timer <= 0:
			punch_state = PunchState.IDLE
	
	if punch_state == PunchState.DANGER:
		for body in $PunchHitbox.get_overlapping_bodies():
			if body is FactoryPlayer and body != self and not body.is_stunned:
				var space_state = get_world_3d().direct_space_state
				var to = position + facing_direction * PUNCH_HITBOX_DISTANCE
				var raycast_params = PhysicsRayQueryParameters3D.create(position, to, 4)  # Collision layer 3 only
				var raycast_result = space_state.intersect_ray(raycast_params)
				if raycast_result:  # A wall is between the players
					continue
				var drop_vector = body.position - position
				drop_vector.y = randf_range(0.0, 1.0)
				body.stun(drop_vector, true)
	
	var colors = [
		Color(0.5, 1.0, 0.5),
		Color(1.0, 0.5, 0.5),
		Color(1.0, 1.0, 0.5)
	]
	var new_material = StandardMaterial3D.new()
	new_material.albedo_color = colors[punch_state]
	$PunchHitbox/PunchIndicatorMesh.set_surface_override_material(0, new_material)


func _physics_process(delta: float) -> void:
	var direction = get_direction()
	if direction:
		if punch_state != PunchState.IDLE:
			facing_direction = punch_direction
		else:
			var angle_change = rad_to_deg(direction.angle_to(previous_direction))
			if angle_change <= JOYSTICK_SNAPBACK_ANGLE:
				facing_direction = direction
	if is_stunned:
		direction = Vector3.ZERO  # No movement when stunned
		
	update_velocity(direction)
	move_and_slide()
	throw_tick(delta)
	stun_tick(delta)
	punch_tick(delta)
	
	# Update carried fuel position
	if carried_fuel_node != null:
		carried_fuel_node.global_position = global_position + carried_fuel_position.position
		carried_fuel_node.rotation = Vector3.ZERO
	
	current_pickup_cooldown = move_toward(current_pickup_cooldown, 0, delta)
	
	previous_direction = direction


func _process(delta: float) -> void:
	# TODO: move non-graphical stuff from here into _physics_process
	
	update_strength_bar_position()
