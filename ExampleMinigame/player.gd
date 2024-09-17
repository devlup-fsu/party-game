extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


@export var player: Controls.Player
@export var color: Color


func _ready() -> void:
	var material = $MeshInstance3D.get_surface_override_material(0)
	if material is StandardMaterial3D:
		material.albedo_color = color


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Controls.is_action_just_pressed(player, "core_player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Controls.get_vector(player, "core_player_left", "core_player_right", "core_player_up", "core_player_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
