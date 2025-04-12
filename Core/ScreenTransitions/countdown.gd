extends Node2D
class_name CountdownScene


const ANIMATION_START_SCALE = 10.0
const ANIMATION_END_SCALE = 1.0
const ANIMATION_DURATION = 0.25

var count = 4.0
var animation_progress = 0.0
var on_finish: Callable


func change_label(new_text: String):
	animation_progress = 0.0
	%CountdownLabel.text = new_text


func animate_label():
	var progress_adjusted = remap(animation_progress, 0.0, ANIMATION_DURATION, 0.0, 1.0)
	var progress_eased = ease(progress_adjusted, 0.2)
	var current_scale = remap(progress_eased, 0.0, 1.0, ANIMATION_START_SCALE, ANIMATION_END_SCALE)
	var current_alpha = progress_eased
	$LabelContainer.scale = Vector2(current_scale, current_scale)
	
	var viewport = get_viewport()
	if viewport != null:
		var screen_center = viewport.size / 2.0
		$LabelContainer.position = screen_center - %CountdownLabel.size / 2 * current_scale
		$LabelContainer.modulate.a = current_alpha


func _process(delta: float) -> void:
	%CountdownLabel.visible = true
	var prev_count_int = int(count)
	count = move_toward(count, 0.0, delta)
	
	if count == 0.0:
		on_finish.call()
	
	var count_int = int(count)
	if count_int != prev_count_int:
		if count_int == 0:
			change_label('GO!')
		else:
			change_label(str(count_int))
	
	# Update label animation
	animation_progress = move_toward(animation_progress, ANIMATION_DURATION, delta)
	animate_label()
