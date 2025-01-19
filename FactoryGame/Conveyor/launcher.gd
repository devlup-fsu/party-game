extends Node3D


@onready var parent: Node3D = get_parent()

const LAUNCH_DELAY = 0.5
var launch_countdown := -1.0

enum FlipperAnimationState {
	IDLE,
	FLIP,
	FLIPPED,
	RETURN
}

const FLIPPER_FLIPPED_WAIT_TIME = 1.0
var flipper_animation_state := FlipperAnimationState.IDLE
var flipper_animation_timer := 0.0


func _ready() -> void:
	if not Engine.is_editor_hint():
		$Sprite3D.visible = false;
		

func _process(delta):
	if launch_countdown > 0:
		launch_countdown -= delta
		if launch_countdown <= 0.0:
			var velocity_vector := Vector3.BACK.rotated(Vector3(0, 1, 0), rotation.y)
			velocity_vector.y = 2.5
			velocity_vector *= 7.5
			for body in $Area3D.get_overlapping_bodies():
				body.linear_velocity += velocity_vector
			flipper_animation_state = FlipperAnimationState.FLIP
			launch_countdown = -1.0
	
	if flipper_animation_state == FlipperAnimationState.FLIP:
		$FlipperMesh.rotation.x += 10.0 * delta;
		if $FlipperMesh.rotation.x >= deg_to_rad(90.0):
			flipper_animation_state = FlipperAnimationState.FLIPPED
			flipper_animation_timer = FLIPPER_FLIPPED_WAIT_TIME
	elif flipper_animation_state == FlipperAnimationState.FLIPPED:
		flipper_animation_timer -= delta
		if flipper_animation_timer <= 0.0:
			flipper_animation_state = FlipperAnimationState.RETURN
	elif flipper_animation_state == FlipperAnimationState.RETURN:
		$FlipperMesh.rotation.x -= 2.0 * delta;
		if $FlipperMesh.rotation.x <= 0.0:
			flipper_animation_state = FlipperAnimationState.IDLE


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Fuel and launch_countdown == -1.0:
		launch_countdown = LAUNCH_DELAY
