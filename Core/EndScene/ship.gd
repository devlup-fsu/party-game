extends MeshInstance3D


const SPEED = 0.005


var should_fly = false
var target_height: float = 0.0
var initial_height = 0.0
var progress = 0.0

func _ready() -> void:
	initial_height = position.y


func _physics_process(delta: float) -> void:
	if not should_fly:
		return
	
	if position.y < target_height + initial_height:
		progress += SPEED
		position.y = target_height * smoothstep(0, 1, progress) + initial_height
	else:
		should_fly = false
		$ScoreLabel.visible = true
