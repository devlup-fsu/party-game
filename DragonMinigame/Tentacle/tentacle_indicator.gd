extends MeshInstance3D
class_name DragonGameIndicator


@onready var indicator_material = mesh.surface_get_material(0)


enum IndicatorFadeState {
	FADE_IN,
	FADE_OUT,
	FADED_IN,
	FADED_OUT
}

const FADE_DURATION = 0.2
const MAX_ALPHA = 0.5

# Time between indication and tentacle slamming
const INDICATOR_DELAY = 1.0


var fade_state = IndicatorFadeState.FADED_OUT
var fade_timer = 0.0


func _ready() -> void:
	indicator_material.albedo_color.a = 0.0


func fade(fade_in: bool):
	if fade_in:
		indicator_material.albedo_color.a = 0.0
		fade_state = IndicatorFadeState.FADE_IN
	else:
		fade_state = IndicatorFadeState.FADE_OUT


func _physics_process(delta: float) -> void:
	# Fade tentacle indicators
	if fade_state == IndicatorFadeState.FADE_IN:
		fade_timer = move_toward(fade_timer, FADE_DURATION, delta)
		var new_alpha = remap(fade_timer, 0.0, FADE_DURATION, 0.0, MAX_ALPHA)
		indicator_material.albedo_color.a = new_alpha
		if fade_timer == FADE_DURATION:
			fade_state = IndicatorFadeState.FADED_IN
			fade_timer = 0.0
	
	elif fade_state == IndicatorFadeState.FADE_OUT:
		fade_timer = move_toward(fade_timer, FADE_DURATION, delta)
		var new_alpha = remap(fade_timer, 0.0, FADE_DURATION, MAX_ALPHA, 0.0)
		indicator_material.albedo_color.a = new_alpha
		if fade_timer == FADE_DURATION:
			fade_state = IndicatorFadeState.FADED_OUT
			fade_timer = 0.0
