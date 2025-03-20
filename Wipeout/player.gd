class_name WipeoutPlayer
extends CharacterBody3D

const JUMP_VEL = 4
const GRAVITY_ACC = -4

signal hit_by_sweeper(player: WipeoutPlayer)

@export var player: Controls.Player


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY_ACC * delta

	# Handle jump.
	if Controls.is_action_just_pressed(player, "core_player_jump") and is_on_floor():
		velocity.y = JUMP_VEL

	move_and_slide()
	
	for collision_idx in range(get_slide_collision_count()):
		var collision = get_slide_collision(collision_idx)
		if collision.get_collider() is WipeoutSweeper:
			hit_by_sweeper.emit(self)
			$CollisionShape3D.disabled = true
