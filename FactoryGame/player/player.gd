extends CharacterBody3D
class_name FactoryPlayer

@export var player_number: Controls.Player


@onready var throw_strength_bar = $ThrowStrengthBar
@onready var player_mesh = $MeshInstance3D
@onready var carried_fuel_position = $CarriedFuelPosition


var stunned_material = preload("res://FactoryGame/resources/materials/temp_stunned_material.tres")

const PLAYER_COLORS = [
	Color(1, 0.5, 0),
	Color(0, 0.6, 0.9),
	Color(1, 0, 0.8),
	Color(0.5, 0.5, 1)
]

const MAX_VELOCITY = 9
const ACCELERATION = 2.5
const FRICTION = 2
const JUMP_VELOCITY = 4.5
const JOYSTICK_CARDINAL_SNAP_ANGLE = 0.075

const PICKUP_COOLDOWN = 0.2  # seconds
const MAX_THROW_CHARGE = 0.75
const THROW_STRENGTH_HORIZONTAL = 20
const THROW_STRENGTH_VERTICAL = 0.2

const THROW_BAR_SCALE = 1000
const THROW_BAR_SMOOTHING_SPEED: float = 0.35
const THROW_STRENGTH_PLAYER_VELOCITY_INFLUENCE = 0.3
const STUN_DURATION = 2.0


# TODO: swap this out with right stick input later on or something more intuitive
var facing_direction = Vector3(1, 0, 0);
var prev_throwbutton_state = false;

var points = 0
var carried_fuel_node: Fuel = null
var current_pickup_cooldown = 0
var throw_charge = 0.0
var isStunned: bool = false # gets stunned when a dangerous fuel cell collides with player
var currentStunDuration = STUN_DURATION

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
	throw_strength_bar.max_value = MAX_THROW_CHARGE * THROW_BAR_SCALE
	throw_strength_bar.visible = false
	throw_strength_bar.modulate = Color(1, 1, 1, 0.8)


func get_direction() -> Vector3:
	var input_dir: Vector2
	input_dir = Controls.get_vector(player_number, "core_player_left", "core_player_right", "core_player_up", "core_player_down")
	input_dir.x = 0.0 if abs(input_dir.x) < JOYSTICK_CARDINAL_SNAP_ANGLE else input_dir.x
	input_dir.y = 0.0 if abs(input_dir.y) < JOYSTICK_CARDINAL_SNAP_ANGLE else input_dir.y
	return (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()


func update_velocity(direction: Vector3):
	if isStunned: # wont update velocity when stunned
		velocity.x = 0
		velocity.y = 0
		velocity.z = 0
		return
	if direction.x:
		velocity.x = clamp(velocity.x + direction.x * ACCELERATION, -MAX_VELOCITY, MAX_VELOCITY)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	if direction.z:
		velocity.z = clamp(velocity.z + direction.z * ACCELERATION, -MAX_VELOCITY, MAX_VELOCITY)
	else:
		velocity.z = move_toward(velocity.z, 0, FRICTION)


func reset_throw_charge():
	current_pickup_cooldown = PICKUP_COOLDOWN
	throw_charge = 0.0
	throw_strength_bar.visible = false
	throw_strength_bar.value = 0

func throw_tick(delta: float):
	var current_throwbutton_state: bool
	current_throwbutton_state = Controls.is_action_pressed(player_number, 'core_player_jump')
	
	if carried_fuel_node != null:
		if current_throwbutton_state:
			throw_charge = move_toward(throw_charge, MAX_THROW_CHARGE, delta)
			throw_strength_bar.visible = true
			throw_strength_bar.value = throw_charge * THROW_BAR_SCALE
		
		elif prev_throwbutton_state:
			var throw_direction = Vector3(facing_direction.x, THROW_STRENGTH_VERTICAL, facing_direction.z)
			carried_fuel_node.linear_velocity = throw_direction * throw_charge \
				* THROW_STRENGTH_HORIZONTAL \
				+ (velocity * THROW_STRENGTH_PLAYER_VELOCITY_INFLUENCE)
			var angular_vector = throw_direction.rotated(Vector3(0, 1, 0), PI/4) * throw_charge * 10
			carried_fuel_node.angular_velocity = angular_vector
			carried_fuel_node.ifDangerous = true # sets if dangerous to true once the fuel cell is thrown
			carried_fuel_node.being_carried = false
			carried_fuel_node = null
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


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var direction = get_direction()
	if direction:
		facing_direction = direction
		
	update_velocity(direction)
	move_and_slide()
	throw_tick(delta)


func _process(delta: float) -> void:
	if carried_fuel_node != null:
		carried_fuel_node.global_position = global_position + carried_fuel_position.position
		carried_fuel_node.rotation = Vector3.ZERO
	current_pickup_cooldown = move_toward(current_pickup_cooldown, 0, delta)
	
	if isStunned == true:
		currentStunDuration = move_toward(currentStunDuration, 0, delta) # reduces current stun duration by delta until 0
		if currentStunDuration == 0:
			isStunned = false
			currentStunDuration = STUN_DURATION
			reset_player_material()
	
	update_strength_bar_position()
