extends CharacterBody3D


const JUMP_VEL = 4
const GRAVITY_ACC = -4

@export var player: Controls.Player


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY_ACC * delta

	# Handle jump.
	if Controls.is_action_just_pressed(player, "core_player_jump") and is_on_floor():
		velocity.y = JUMP_VEL

	move_and_slide()
