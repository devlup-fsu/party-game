extends Area3D
class_name DragonGameTentacle

enum SlamState {
	IDLE,
	SLAM,
	RETURN
}

const SLAM_DURATION = 0.05
const RETURN_DURATION = 0.25

var slam_state = SlamState.IDLE
var slam_timer = 0.0


func slam():
	slam_state = SlamState.SLAM


func _physics_process(delta: float) -> void:
	if slam_state == SlamState.SLAM:
		slam_timer = move_toward(slam_timer, SLAM_DURATION, delta)
		rotation.x = remap(slam_timer, 0.0, SLAM_DURATION, 0.0, PI / 2)
		if slam_timer == SLAM_DURATION:
			slam_state = SlamState.RETURN
			slam_timer = 0.0
	if slam_state == SlamState.RETURN:
		slam_timer = move_toward(slam_timer, RETURN_DURATION, delta)
		rotation.x = remap(slam_timer, 0.0, RETURN_DURATION, PI / 2,0.0)
		if slam_timer == RETURN_DURATION:
			slam_state = SlamState.IDLE
			slam_timer = 0.0
	
